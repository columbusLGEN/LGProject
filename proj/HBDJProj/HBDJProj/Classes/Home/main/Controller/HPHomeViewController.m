//
//  HPHomeViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPHomeViewController.h"

#import "LGSegmentControl.h"
#import "LGNavigationSearchBar.h"

#import <SDCycleScrollView/SDCycleScrollView.h>
#import <SwipeTableView/SwipeTableView.h>

#import "HPMicrolessonView.h"
#import "HPBuildTableView.h"
#import "HPDigitalCollectionView.h"
#import "HPNetworkFailureView.h"

#import "EDJHomeModel.h"
#import "EDJMicroBuildModel.h"
#import "EDJDigitalModel.h"
#import "EDJHomeImageLoopModel.h"
#import "EDJMicroLessionAlbumModel.h"

#import "HPSearchViewController.h"
#import "HPPartyBuildDetailViewController.h"
#import "HPPointNewsTableViewController.h"
#import "HPAlbumTableViewController.h"
#import "HPAudioVideoViewController.h"
#import "HPBookInfoViewController.h"

#import "EDJHomeIndexRequest.h"
#import "LGDidSelectedNotification.h"

static NSInteger requestLength = 1;

@interface HPHomeViewController ()<
SwipeTableViewDataSource
,SwipeTableViewDelegate
,SDCycleScrollViewDelegate
,LGNavigationSearchBarDelelgate
,LGSegmentControlDelegate,
HPNetworkFailureViewDelegate>
@property (strong,nonatomic) SwipeTableView * swipeTableView;
@property (strong,nonatomic) STHeaderView *header;
@property (strong,nonatomic) SDCycleScrollView *imgLoop;
@property (strong,nonatomic) LGSegmentControl *segment;
@property (weak,nonatomic) LGNavigationSearchBar *fakeNav;

@property (strong,nonatomic) HPMicrolessonView *lessonTableview;
@property (strong,nonatomic) HPBuildTableView *buildTableview;
@property (strong,nonatomic) HPDigitalCollectionView *digitalCollectionView;

@property (strong,nonatomic) MBProgressHUD *HUD;

@property (strong,nonatomic) EDJHomeModel *homeModel;

/** 图片轮播模型 */
@property (strong,nonatomic) NSArray *imageLoops;
@property (strong,nonatomic) NSArray *microModels;

@property (strong,nonatomic) NSArray<EDJMicroBuildModel *> *buildModels;
@property (assign,nonatomic) NSInteger buildOffset;
@property (strong,nonatomic) NSArray *digitalModels;
@property (assign,nonatomic) NSInteger digitalOffset;

@property (assign,nonatomic) NSInteger currentIndex;

@property (weak,nonatomic) HPNetworkFailureView *emptyView;


@end

@implementation HPHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
//    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    
    _swipeTableView.swipeHeaderView = self.header;
    _swipeTableView.swipeHeaderBar = self.segment;
    _swipeTableView.swipeHeaderTopInset = kNavHeight;
    
    [self.view addSubview:_swipeTableView];
    
    /// 添加自定义导航栏
    LGNavigationSearchBar *fakeNav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    fakeNav.delegate = self;
    [self.view addSubview:fakeNav];
    _fakeNav = fakeNav;
    
    [self homeReloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedModel:) name:LGDidSelectedNotification object:nil];
    
    _buildOffset = 0;
    _digitalOffset = 0;
}


#pragma mark - SwipeTableView M
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 3;
}
- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    if (index == 0) {
        HPMicrolessonView *tableview = self.lessonTableview;
        tableview.dataArray = self.microModels;
        view = self.lessonTableview;
    }else if (index == 1) {
        /// 返回党建要闻
        HPBuildTableView *tableview = self.buildTableview;
        tableview.dataArray = self.buildModels;
        view = self.buildTableview;
    }else{
        /// 返回数字阅读
        HPDigitalCollectionView *collectionView = self.digitalCollectionView;
        collectionView.dataArray = self.digitalModels;
        view = self.digitalCollectionView;
    }
    [self configRefreshHeaderForItem:view];
    return view;
}
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView{
    [self.segment elfAnimateWithIndex:swipeView.currentItemIndex];

}
/**
 *  以下两个代理，在未定义宏 #define ST_PULLTOREFRESH_HEADER_HEIGHT，并自定义下拉刷新的时候，必须实现
 *  如果设置了下拉刷新的宏，以下代理可根据需要实现即可
 */
- (BOOL)swipeTableView:(SwipeTableView *)swipeTableView shouldPullToRefreshAtIndex:(NSInteger)index {
    return YES;
}
- (CGFloat)swipeTableView:(SwipeTableView *)swipeTableView heightForRefreshHeaderAtIndex:(NSInteger)index {
    return MJRefreshHeaderHeight;
}
- (void)configRefreshHeaderForItem:(UIScrollView *)itemView {
    MJRefreshHeader *header = itemView.mj_header;
    if ([itemView isKindOfClass:[UICollectionView class]]) {
        header.ignoredScrollViewContentInsetTop = self.topInsetHeight + 10;
    }else{
        header.ignoredScrollViewContentInsetTop = self.topInsetHeight;
    }
}

- (void)homeReloadData{

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
            [_lessonTableview.mj_header endRefreshing];
            [_buildTableview.mj_header endRefreshing];
            [_digitalCollectionView.mj_header endRefreshing];
            [self.swipeTableView reloadData];
        }];
        
    } failure:^(id failureObj) {
        [self.HUD hideAnimated:YES];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self lg_addEmptyView];
        }];
        
    }];
}

#pragma mark - HPNetworkFailureViewDelegate
- (void)djemptyViewClick{
    [self homeReloadData];
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
        NSMutableArray *buildArray = [NSMutableArray arrayWithArray:_buildTableview.dataArray];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
            [buildArray addObject:model];
        }];
        _buildOffset = buildArray.count;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_buildTableview.mj_footer endRefreshing];
            _buildTableview.dataArray = buildArray;
        }];
    } failure:^(id failureObj) {
        NSLog(@"buildpointnews_failure : %@",failureObj);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_buildTableview.mj_footer endRefreshing];
        }];
    }];
}
/// MARK: 数字阅读加载更多数据
- (void)digitalLoadMoreDatas{
    [DJNetworkManager homeDigitalListWithOffset:_digitalOffset length:requestLength sort:0 success:^(id responseObj) {
        NSLog(@"digitallist_response: %@",responseObj);
        NSArray *array = (NSArray *)responseObj;
        NSMutableArray *digitalArray = [NSMutableArray arrayWithArray:_digitalCollectionView.dataArray];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EDJDigitalModel *model = [EDJDigitalModel mj_objectWithKeyValues:obj];
            [digitalArray addObject:model];
        }];
        _digitalOffset = digitalArray.count;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_digitalCollectionView.mj_footer endRefreshing];
            _digitalCollectionView.dataArray = digitalArray;
        }];
    } failure:^(id failureObj) {
        NSLog(@"digitallist_failure: %@",failureObj);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_digitalCollectionView.mj_footer endRefreshing];
        }];
    }];
    
}

#pragma mark - setter
- (void)setImageLoops:(NSArray *)imageLoops{
    _imageLoops = imageLoops;
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    [imageLoops enumerateObjectsUsingBlock:^(EDJHomeImageLoopModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [imgUrls addObject:model.classimg];
//        NSLog(@"imgloop.classimg -- %@",model.classimg);
    }];
    _imgLoop.imageURLStringsGroup = imgUrls.copy;
}


#pragma mark - LGSegmentControlDelegate
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click{
    [self.swipeTableView scrollToItemAtIndex:click animated:YES];
    _currentIndex = click;
    
//    if (_currentIndex == 0) {
//        self.lessonTableview.dataArray = self.microModels;
//    }
//    if (_currentIndex == 1) {
//        self.buildTableview.dataArray = self.buildModels;
//    }
//    if (_currentIndex == 2) {
//        self.digitalCollectionView.dataArray = self.digitalModels;
//    }
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
            NSLog(@"党课单条 -- %@",lesson);
            
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

#pragma mark - getter
- (STHeaderView *)header{
    if (!_header) {
        _header = [[STHeaderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, homeImageLoopHeight)];
        [_header addSubview:self.imgLoop];
    }
    return _header;
}
- (SDCycleScrollView *)imgLoop{
    if (_imgLoop == nil) {
        _imgLoop = [[SDCycleScrollView alloc] initWithFrame:_header.bounds];
        _imgLoop.placeholderImage = nil;
        _imgLoop.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _imgLoop.delegate = self;
        
//            _imgLoop.imageURLStringsGroup = @[
//                                              @"https://goss.vcg.com/creative/vcg/800/version23/VCG21gic13374057.jpg",
//                                              @"http://dl.bizhi.sogou.com/images/2013/12/19/458657.jpg",
//                                              @"https://goss3.vcg.com/creative/vcg/800/version23/VCG21gic19568254.jpg"];
        /// testcode
//        _imgLoop.imageURLStringsGroup = @[@"http://123.59.197.176/group1/M00/00/0F/CgoKBFsWHkuAOsPsAA2dBEpoyMs503.png",
//                                          @"http://123.59.197.176/group1/M00/00/0F/CgoKBFsWHkuAOsPsAA2dBEpoyMs503.png",
//                                          @"http://123.59.197.176/group1/M00/00/0F/CgoKBFsWHkuAOsPsAA2dBEpoyMs503.png"];
        
    }
    return _imgLoop;
}
- (LGSegmentControl *)segment{
    if (_segment == nil) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
        NSArray *titles = @[@"微党课",@"党建要闻",@"数字阅读"];
        for (int i = 0; i < 3; i++) {
            LGSegmentControlModel *model = [LGSegmentControlModel new];
            model.title = titles[i];
            model.imageName = [NSString stringWithFormat:@"home_segment_icon%d",i];
            [arr addObject:model];
        }
        _segment = [[LGSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, homeSegmentHeight) models:arr.copy];
        _segment.elfColor = [UIColor EDJMainColor];
        _segment.delegate = self;
    }
    return _segment;
}

//@property (strong,nonatomic) HPMicrolessonView *lessonTableview;
//@property (strong,nonatomic) HPBuildTableView *buildTableview;
//@property (strong,nonatomic) HPDigitalCollectionView *digitalCollectionView;
- (HPMicrolessonView *)lessonTableview{
    if (!_lessonTableview) {
        CGRect rect = _swipeTableView.bounds;
        rect.size.height -= kTabBarHeight;
        _lessonTableview = [[HPMicrolessonView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _lessonTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(homeReloadData)];
    }
    return _lessonTableview;
}
- (HPBuildTableView *)buildTableview{
    if (!_buildTableview) {
        CGRect rect = _swipeTableView.bounds;
        rect.size.height -= kTabBarHeight;
        _buildTableview = [[HPBuildTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _buildTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(homeReloadData)];
        _buildTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(buildPointNewsLoadMoreDatas)];;
    }
    return _buildTableview;
}
- (HPDigitalCollectionView *)digitalCollectionView{
    if (!_digitalCollectionView) {
        CGRect rect = _swipeTableView.bounds;
        rect.size.height -= kTabBarHeight;
        rect.origin.y += 10;
        rect.size.height -= 10;
        _digitalCollectionView = [[HPDigitalCollectionView alloc] initWithFrame:rect];;
        _digitalCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(homeReloadData)];
        _digitalCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(digitalLoadMoreDatas)];
    }
    return _digitalCollectionView;
}

- (CGFloat)topInsetHeight{
    return homeImageLoopHeight + homeSegmentHeight;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

/// 模拟数据
/// 微党课模拟数据
//    NSMutableArray *microModels  = [NSMutableArray array];
//    for (int i = 0; i < 4; i++) {
//        EDJMicroLessionAlbumModel *model = [EDJMicroLessionAlbumModel new];
//        if (i == 0) {
////            model.imgs = @[@"",@""];
//        }
//        model.classlist = @[[DJDataBaseModel new],
//                            [DJDataBaseModel new],
//                            [DJDataBaseModel new]];
//        [microModels addObject:model];
//    }
//    /// 党建要闻模拟数据
//    NSMutableArray *buildModels = [NSMutableArray new];
//    for (int i = 0; i < 20; i++) {
//        EDJMicroBuildModel *model = [EDJMicroBuildModel new];
//        model.showInteractionView = YES;
//        NSMutableArray *imgs = [NSMutableArray new];
//        int k = arc4random_uniform(3);
//        if (k == 2) {
//            k++;
//        }
//        for (int j = 0;j < k; j++) {
//            [imgs addObject:@"build"];
//        }
//        model.imgs = imgs.copy;
//        [buildModels addObject:model];
//    }
//    /// 数字阅读模拟数据
//    NSMutableArray *digitalModels  = [NSMutableArray array];
//    for (int i = 0; i < 10; i++) {
//        EDJDigitalModel *model = [EDJDigitalModel new];
//        [digitalModels addObject:model];
//    }
//    self.microModels = microModels.copy;
//    self.buildModels = buildModels.copy;
//    self.digitalModels = digitalModels.copy;
//    [self.swipeTableView reloadData];
