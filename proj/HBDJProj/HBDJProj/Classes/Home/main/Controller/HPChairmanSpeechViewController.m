//
//  HPChairmanSpeechViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPChairmanSpeechViewController.h"

// view
#import "LGSegmentControl.h"
#import "HPNetworkFailureView.h"
#import "LGNavigationSearchBar.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

// controller
#import "DJHomeSearchViewController.h"
#import "HPBookInfoViewController.h"
#import "HPBuildTableViewController.h"
#import "HPAlbumTableViewController.h"
#import "HPMicrolessonViewController.h"
#import "HPPointNewsTableViewController.h"
#import "HPDigitalCollectionViewController.h"

// model
#import "EDJHomeModel.h"
#import "EDJDigitalModel.h"
#import "EDJMicroBuildModel.h"
#import "EDJHomeImageLoopModel.h"

// other
#import "LTScrollView-Swift.h"
#import "DJMediaDetailTransAssist.h"
#import "LGDidSelectedNotification.h"
#import "DJDataSyncer.h"
#import "EDJMicroLessionAlbumModel.h"

static NSInteger requestLength = 10;

@interface HPChairmanSpeechViewController ()<
 LGSegmentControlDelegate
,SDCycleScrollViewDelegate
,LTSimpleScrollViewDelegate
,HPNetworkFailureViewDelegate
,LGNavigationSearchBarDelelgate>

// view
@property (strong,nonatomic) UIView *header;
@property (strong,nonatomic) SDCycleScrollView *imgLoop;
@property (strong,nonatomic) LGSegmentControl  *segment;
@property (weak,nonatomic)   LGNavigationSearchBar *fakeNav;
@property (strong, nonatomic) LTLayout *layout;
@property (strong, nonatomic) LTSimpleManager *managerView;
@property (weak,nonatomic) HPNetworkFailureView *emptyView;

// array 页面配置
@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;
// array 数据
@property (strong,nonatomic) NSArray *imageLoops;
@property (strong,nonatomic) NSArray *microModels;
@property (strong,nonatomic) NSArray<EDJMicroBuildModel *> *buildModels;
@property (strong,nonatomic) NSArray *digitalModels;

// vc
@property (strong,nonatomic) HPMicrolessonViewController *mlvc;
@property (strong,nonatomic) HPBuildTableViewController *btvc;
@property (strong,nonatomic) HPDigitalCollectionViewController *dcvc;

// model
@property (strong,nonatomic) EDJHomeModel *homeModel;

// other
@property (assign,nonatomic) NSInteger buildOffset;
@property (assign,nonatomic) NSInteger digitalOffset;
@property (strong,nonatomic) DJMediaDetailTransAssist *transAssist;

@end

@implementation HPChairmanSpeechViewController{
    DJDataSyncer *dataSyncer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self homeReloadDataWithScrollView:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configUI{
    
    /// 添加自定义导航栏
    LGNavigationSearchBar *fakeNav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    fakeNav.delegate = self;
    [self.view addSubview:fakeNav];
    _fakeNav = fakeNav;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.managerView];
    
    /// 配置header
    __weak typeof(self) weakSelf = self;
    [self.managerView configHeaderView:^UIView * _Nullable{
        return weakSelf.header;
    }];
    
    /// 下拉刷新回调
    [self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
        __weak typeof(scrollView) weakScrollView = scrollView;
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
            [self homeReloadDataWithScrollView:strongScrollView];
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedModel:) name:LGDidSelectedNotification object:nil];
    
    dataSyncer = DJDataSyncer.new;
}
// 获取数据
- (void)homeReloadDataWithScrollView:(UIScrollView *)scrollView{
    [_btvc.tableView.mj_footer resetNoMoreData];
    /// 添加 页面网络指示器, 有添加，就要在每个回调中有删除
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[LGLoadingAssit sharedInstance] homeAddLoadingViewTo:self.view];
    });
    
    /// 请求数据
    [DJHomeNetworkManager homeIndexWithSuccess:^(id responseObj) {
        [_emptyView removeFromSuperview];
        _emptyView = nil;
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        
        EDJHomeModel *homeModel = [EDJHomeModel mj_objectWithKeyValues:responseObj];
        _homeModel = homeModel;
        self.imageLoops = homeModel.imageLoops;
        self.microModels = homeModel.microLessons;
        self.buildModels = homeModel.pointNews;
        self.digitalModels = homeModel.digitals;
        
        NSMutableArray *arrmu = NSMutableArray.new;
        for (NSInteger i = 0; i < homeModel.microLessons.count; i++) {
            EDJMicroLessionAlbumModel *album = homeModel.microLessons[i];
            for (NSInteger j = 0; j < album.classlist.count; j++) {
                DJDataBaseModel *lesson = album.classlist[j];

                [arrmu addObject:lesson];
            }
        }
        dataSyncer.home_lessons = arrmu.copy;
        dataSyncer.home_news = self.buildModels;
        
        _buildOffset = self.buildModels.count;
        _digitalOffset = self.digitalModels.count;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _mlvc.dataArray = _microModels;
            _btvc.dataArray = _buildModels;
            _dcvc.dataArray = _digitalModels;
            if (scrollView) [scrollView.mj_header endRefreshing];
        }];
        
    } failure:^(id failureObj) {
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self lg_addEmptyView];
            if (scrollView) [scrollView.mj_header endRefreshing];
        }];
        
    }];
}

#pragma mark - HPNetworkFailureViewDelegate
// 点击无数据视图 刷新数据
- (void)djemptyViewClick{
    [self homeReloadDataWithScrollView:nil];
}
// 添加无数据视图
- (void)lg_addEmptyView{
    if (!_emptyView) {
        HPNetworkFailureView *empty = [HPNetworkFailureView DJEmptyView];
        empty.delegate = self;
        empty.frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight);
        [self.view addSubview:empty];
        _emptyView = empty;
    }
}

/// MARK: 党建要闻加载更多数据
- (void)buildPointNewsLoadMoreDatas{
    
    [DJHomeNetworkManager homeChairmanPoineNewsClassid:_homeModel.newsClassId offset:_buildOffset length:requestLength sort:1 success:^(id responseObj) {
        NSLog(@"buildpointnews_response : %@",responseObj);
        NSArray *array = (NSArray *)responseObj;
        
        if (array.count == 0) {
            [_btvc.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            NSMutableArray *buildArray = [NSMutableArray arrayWithArray:_btvc.dataArray];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
                [buildArray addObject:model];
            }];
            _buildOffset = buildArray.count;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_btvc.tableView.mj_footer endRefreshing];
                _btvc.dataArray = buildArray;
                dataSyncer.home_news = buildArray.copy;
            }];
        }
        
        
    } failure:^(id failureObj) {
        NSLog(@"buildpointnews_failure : %@",failureObj);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_btvc.tableView.mj_footer endRefreshing];
        }];
    }];
}
/// MARK: 数字阅读加载更多数据
- (void)digitalLoadMoreDatas{
    [DJHomeNetworkManager homeDigitalListWithOffset:_digitalOffset length:requestLength sort:0 success:^(id responseObj) {
        NSLog(@"digitallist_response: %@",responseObj);
        NSArray *array = (NSArray *)responseObj;
        NSMutableArray *digitalArray = [NSMutableArray arrayWithArray:_dcvc.dataArray];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EDJDigitalModel *model = [EDJDigitalModel mj_objectWithKeyValues:obj];
            [digitalArray addObject:model];
        }];
        _digitalOffset = digitalArray.count;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_dcvc.collectionView.mj_footer endRefreshing];
            _dcvc.dataArray = digitalArray;
        }];
    } failure:^(id failureObj) {
        NSLog(@"digitallist_failure: %@",failureObj);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_dcvc.collectionView.mj_footer endRefreshing];
        }];
    }];
    
}
/// 设置轮播数据
- (void)setImageLoops:(NSArray *)imageLoops{
    _imageLoops = imageLoops;
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    [imageLoops enumerateObjectsUsingBlock:^(EDJHomeImageLoopModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [imgUrls addObject:model.classimg];
    }];
    _imgLoop.imageURLStringsGroup = imgUrls.copy;
}
/// MARK: lazy load
- (UIView *)header{
    if (!_header) {
        // TODO: Zup_宽高比 16：9
        // self.imgLoopHeight_forAnyScreen --> kHeigh_ScreedWidth9_16
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeigh_ScreedWidth9_16 + homeSegmentHeight + 10)];
        _header.backgroundColor = UIColor.EDJGrayscale_F3;
        [_header addSubview:self.imgLoop];
        [_header addSubview:self.segment];
    }
    return _header;
}
- (SDCycleScrollView *)imgLoop{
    if (_imgLoop == nil) {
        // TODO: Zup
        /// homeImageLoopHeight --> self.imgLoopHeight_forAnyScreen --> kHeigh_ScreedWidth9_16
        _imgLoop = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kHeigh_ScreedWidth9_16) delegate:self placeholderImage:DJImgloopPImage];
        _imgLoop.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _imgLoop;
}
- (LGSegmentControl *)segment{
    if (_segment == nil) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < 3; i++) {
            LGSegmentControlModel *model = [LGSegmentControlModel new];
            model.imageName = [NSString stringWithFormat:@"home_segment_icon%d",i];
            [arr addObject:model];
        }
        // TODO: Zup_self.imgLoopHeight_forAnyScreen --> kHeigh_ScreedWidth9_16
        _segment = [[LGSegmentControl alloc] initWithFrame:CGRectMake(0, kHeigh_ScreedWidth9_16 + 10, kScreenWidth, homeSegmentHeight) models:arr.copy];
        _segment.delegate = self;
    }
    return _segment;
}
- (LTSimpleManager *)managerView {
    if (!_managerView) {
        CGFloat y = kNavHeight;/// 减去header的高度
        CGFloat h = kScreenHeight - y;
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, h) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout];
        _managerView.delegate = self;
//        _managerView.isClickScrollAnimation = true;
        //设置悬停位置
//        _managerView.hoverY = 44;
    }
    return _managerView;
}
-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.titleViewBgColor = [UIColor whiteColor];
        _layout.pageBottomLineColor = [UIColor whiteColor];
        _layout.bottomLineColor = [UIColor EDJMainColor];
        
        _layout.isAverage = true;
        _layout.scale = 1.0;
        _layout.isColorAnimation = false;
        
    }
    return _layout;
}

- (CGFloat)imgLoopHeight_forAnyScreen{
    return  (homeImageLoopHeight * kScreenHeight) / plusScreenHeight;
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"微党课", @"党建要闻", @"数字阅读"];
    }
    return _titles;
}

-(NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}
-(NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *vcs = [NSMutableArray arrayWithCapacity:0];
    /**
     子控制器中:
     self.glt_scrollView = self.tableView;
     */
    
    HPMicrolessonViewController *mlvc = [HPMicrolessonViewController new];
    [vcs addObject:mlvc];
    _mlvc = mlvc;
    
    HPBuildTableViewController *btvc = [HPBuildTableViewController new];
    btvc.superVc = self;
    [vcs addObject:btvc];
    _btvc = btvc;
    
    HPDigitalCollectionViewController *dcvc = [HPDigitalCollectionViewController new];
    dcvc.superVc = self;
    [vcs addObject:dcvc];
    _dcvc = dcvc;
    
    return vcs.copy;
}

- (DJMediaDetailTransAssist *)transAssist{
    if (!_transAssist) {
        _transAssist = [DJMediaDetailTransAssist new];
    }
    return _transAssist;
}

/// MARK: 代理方法
#pragma mark - LGNavigationSearchBarDelelgate -- 导航点击回调
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self beginSearchWithVoice:NO];
}
- (void)voiceButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self beginSearchWithVoice:YES];
}
- (void)beginSearchWithVoice:(BOOL)voice{
    DJHomeSearchViewController *searchVc = [DJHomeSearchViewController new];
    searchVc.voice = voice;
    searchVc.dataSyncer = dataSyncer;
    [self.navigationController pushViewController:searchVc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate -- 轮播图点击回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    EDJHomeImageLoopModel *model = self.imageLoops[index];
    [self.transAssist imgLoopClick:index model:model baseVc:self];
}

#pragma mark - 进入 专辑，微党课，要闻详情，
- (void)didSelectedModel:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    [self.transAssist homeListClick:userInfo baseVc:self];
    
}

#pragma mark - LGSegmentControlDelegate
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click{
    [self.managerView scrollToIndexWithIndex:click];
    
}


@end
