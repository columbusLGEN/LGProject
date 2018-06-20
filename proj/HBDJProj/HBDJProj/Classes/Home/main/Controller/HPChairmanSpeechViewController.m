//
//  HPChairmanSpeechViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPChairmanSpeechViewController.h"

#import "LGNavigationSearchBar.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LGSegmentControl.h"
#import "HPNetworkFailureView.h"

#import "HPMicrolessonViewController.h"
#import "HPBuildTableViewController.h"
#import "HPDigitalCollectionViewController.h"
#import "HPSearchViewController.h"
#import "HPPointNewsTableViewController.h"
#import "HPPartyBuildDetailViewController.h"
#import "HPAudioVideoViewController.h"
#import "HPAlbumTableViewController.h"
#import "HPBookInfoViewController.h"

#import "EDJHomeModel.h"
#import "EDJHomeImageLoopModel.h"
#import "EDJMicroBuildModel.h"
#import "EDJDigitalModel.h"
#import "EDJMicroLessionAlbumModel.h"

#import "LGDidSelectedNotification.h"

#import "LTScrollView-Swift.h"

static NSInteger requestLength = 1;

@interface HPChairmanSpeechViewController ()<
LTSimpleScrollViewDelegate
,LGNavigationSearchBarDelelgate
,LGSegmentControlDelegate
,SDCycleScrollViewDelegate
,HPNetworkFailureViewDelegate>

@property (weak,nonatomic) LGNavigationSearchBar *fakeNav;
@property (strong,nonatomic) UIView *header;
@property (strong,nonatomic) SDCycleScrollView *imgLoop;
@property (strong,nonatomic) LGSegmentControl *segment;

@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;

@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTSimpleManager *managerView;

@property (strong,nonatomic) HPMicrolessonViewController *mlvc;
@property (strong,nonatomic) HPBuildTableViewController *btvc;
@property (strong,nonatomic) HPDigitalCollectionViewController *dcvc;

@property (strong,nonatomic) EDJHomeModel *homeModel;

@property (strong,nonatomic) NSArray *imageLoops;
@property (strong,nonatomic) NSArray *microModels;

@property (strong,nonatomic) NSArray<EDJMicroBuildModel *> *buildModels;
@property (strong,nonatomic) NSArray *digitalModels;
@property (assign,nonatomic) NSInteger buildOffset;
@property (assign,nonatomic) NSInteger digitalOffset;

@property (strong,nonatomic) MBProgressHUD *HUD;
@property (weak,nonatomic) HPNetworkFailureView *emptyView;

@end

@implementation HPChairmanSpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];

    [self homeReloadDataWithScrollView:nil];
}

- (void)configUI{
    
    /// 添加自定义导航栏
    LGNavigationSearchBar *fakeNav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    fakeNav.delegate = self;
    [self.view addSubview:fakeNav];
    _fakeNav = fakeNav;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.managerView];
    
    __weak typeof(self) weakSelf = self;
    [self.managerView configHeaderView:^UIView * _Nullable{
        return weakSelf.header;
    }];
    
    //控制器刷新事件
    [self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
        __weak typeof(scrollView) weakScrollView = scrollView;
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
            [self homeReloadDataWithScrollView:strongScrollView];
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedModel:) name:LGDidSelectedNotification object:nil];
}

- (void)homeReloadDataWithScrollView:(UIScrollView *)scrollView{
    
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.backgroundColor = [UIColor clearColor];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.HUD.backgroundColor = [UIColor whiteColor];
        });
        if (!_HUD) {
            [self.view addSubview:self.HUD];
        }else{
            [self.HUD showAnimated:YES];
        }
        self.HUD.mode = MBProgressHUDModeIndeterminate;
    
    [DJNetworkManager homeIndexWithSuccess:^(id responseObj) {
        [_emptyView removeFromSuperview];
        _emptyView = nil;
        [self.HUD hideAnimated:YES];
        EDJHomeModel *homeModel = [EDJHomeModel mj_objectWithKeyValues:responseObj];
        _homeModel = homeModel;
        self.imageLoops = homeModel.imageLoops;
        self.microModels = homeModel.microLessons;
        self.buildModels = homeModel.pointNews;
        self.digitalModels = homeModel.digitals;
        
        _buildOffset = self.buildModels.count;
        _digitalOffset = self.digitalModels.count;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _mlvc.dataArray = _microModels;
            _btvc.dataArray = _buildModels;
            _dcvc.dataArray = _digitalModels;
            if (scrollView) [scrollView.mj_header endRefreshing];
        }];
        
    } failure:^(id failureObj) {
                [self.HUD hideAnimated:YES];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self lg_addEmptyView];
            if (scrollView) [scrollView.mj_header endRefreshing];
        }];
        
    }];
}

#pragma mark - HPNetworkFailureViewDelegate
- (void)djemptyViewClick{
    [self homeReloadDataWithScrollView:nil];
}
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
    
    [DJNetworkManager homeChairmanPoineNewsClassid:_homeModel.newsClassId offset:_buildOffset length:requestLength sort:0 success:^(id responseObj) {
        NSLog(@"buildpointnews_response : %@",responseObj);
        NSArray *array = (NSArray *)responseObj;
        NSMutableArray *buildArray = [NSMutableArray arrayWithArray:_btvc.dataArray];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
            [buildArray addObject:model];
        }];
        _buildOffset = buildArray.count;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_btvc.tableView.mj_footer endRefreshing];
            _btvc.dataArray = buildArray;
        }];
    } failure:^(id failureObj) {
        NSLog(@"buildpointnews_failure : %@",failureObj);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_btvc.tableView.mj_footer endRefreshing];
        }];
    }];
}
/// MARK: 数字阅读加载更多数据
- (void)digitalLoadMoreDatas{
    [DJNetworkManager homeDigitalListWithOffset:_digitalOffset length:requestLength sort:0 success:^(id responseObj) {
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

- (void)setImageLoops:(NSArray *)imageLoops{
    _imageLoops = imageLoops;
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    [imageLoops enumerateObjectsUsingBlock:^(EDJHomeImageLoopModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [imgUrls addObject:model.classimg];
//        NSLog(@"imgloop.classimg -- %@",model.classimg);
    }];
    _imgLoop.imageURLStringsGroup = imgUrls.copy;
}

- (UIView *)header{
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 293)];
        [_header addSubview:self.imgLoop];
        [_header addSubview:self.segment];
    }
    return _header;
}
- (SDCycleScrollView *)imgLoop{
    if (_imgLoop == nil) {
        _imgLoop = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, homeImageLoopHeight)];
        _imgLoop.placeholderImage = nil;
        _imgLoop.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _imgLoop.delegate = self;
        
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
        _segment = [[LGSegmentControl alloc] initWithFrame:CGRectMake(0, homeImageLoopHeight, kScreenWidth, homeSegmentHeight) models:arr.copy];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - LGNavigationSearchBarDelelgate
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar{
    HPSearchViewController *searchVc = [HPSearchViewController new];
    [self.navigationController pushViewController:searchVc animated:YES];
}
- (void)voiceButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    HPSearchViewController *searchVc = [HPSearchViewController new];
    searchVc.voice = YES;
    [self.navigationController pushViewController:searchVc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    EDJHomeImageLoopModel *model = self.imageLoops[index];
    NSLog(@"model.classid -- %ld",model.seqid);
    switch (index) {
        case 0:{
            /// MARK: 进入习近平要闻列表
            HPPointNewsTableViewController *vc = [HPPointNewsTableViewController new];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            /// 进入 党建要闻详情
            //        imageLoopModel.newsid;
            HPPartyBuildDetailViewController *dvc = [HPPartyBuildDetailViewController new];
            dvc.djDataType = DJDataPraisetypeNews;
            dvc.imageLoopModel = model;
            dvc.coreTextViewType = LGCoreTextViewTypeDefault;
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 2:{
            /// 进入 微党课详情
            HPAudioVideoViewController *dvc = [HPAudioVideoViewController new];
            dvc.imgLoopModel = model;
            /// 用于区分音视频
            dvc.contentType = model.modaltype;
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
    }
}

#pragma mark - notifications
- (void)didSelectedModel:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    //    id model = userInfo[LGDidSelectedModelKey];
    NSInteger skipType = [userInfo[LGDidSelectedSkipTypeKey] integerValue];
    NSInteger index = [userInfo[LGDidSelectedIndexKey] integerValue];
    
    
    switch (skipType) {
        case LGDidSelectedSkipTypeMicrolessonSingle:{
            NSInteger subIndex = [userInfo[LGDidSelectedSubModelIndexKey] integerValue];
            
            /// 先获取专辑
            EDJMicroLessionAlbumModel *alubm = self.microModels[index];
            /// 再获取专辑单条微党课
            DJDataBaseModel *lesson = alubm.classlist[subIndex];
            NSLog(@"单条党课 -- %@",lesson);
            
            /// TODO: 打开正式代码
            /// MARK: 进入微党课正式代码
            //            if (lesson.modaltype == ModelMediaTypeCustom || lesson.modaltype == ModelMediaTypeRichText) {
            //                NSLog(@"数据异常: ");
            //            }else{
            //                HPAudioVideoViewController *avc = [HPAudioVideoViewController new];
            //            avc.model = lesson;
            //                avc.contentType = lesson.modaltype;
            //                [self.navigationController pushViewController:avc animated:YES];
            //            }
            /// 进入微党课单条详情
            /// testcode 第一个cell，打开视频详情
            HPAudioVideoViewController *avc = [HPAudioVideoViewController new];
            if ((index % 2) == 0) {
                avc.contentType = ModelMediaTypeAudio;
            }else{
                avc.contentType = ModelMediaTypeVideo;
            }
            avc.model = lesson;
            [self.navigationController pushViewController:avc animated:YES];
            
        }
            break;
        case LGDidSelectedSkipTypeMicrolessonAlbum:{
            /// MARK: 进入专辑列表
            HPAlbumTableViewController *album = [HPAlbumTableViewController new];
            [self.navigationController pushViewController:album animated:YES];
        }
            break;
        case LGDidSelectedSkipTypeBuildNews:{
            EDJMicroBuildModel *contentModel = self.buildModels[index];
            HPPartyBuildDetailViewController *dvc = [HPPartyBuildDetailViewController new];
            dvc.contentModel = contentModel;
            dvc.coreTextViewType = LGCoreTextViewTypeDefault;
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case LGDidSelectedSkipTypeDigitalBook:{
            EDJDigitalModel *digital = self.digitalModels[index];
            HPBookInfoViewController *vc = [HPBookInfoViewController new];
            vc.model = digital;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
    
}

#pragma mark - LGSegmentControlDelegate
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click{
   
    
}

@end
