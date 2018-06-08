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

@interface HPHomeViewController ()<
SwipeTableViewDataSource
,SwipeTableViewDelegate
,SDCycleScrollViewDelegate
,LGNavigationSearchBarDelelgate
,LGSegmentControlDelegate>
@property (strong,nonatomic) SwipeTableView * swipeTableView;
@property (strong,nonatomic) STHeaderView *header;
@property (strong,nonatomic) SDCycleScrollView *imgLoop;
@property (strong,nonatomic) HPMicrolessonView *microlessonTableView;
@property (strong,nonatomic) LGSegmentControl *segment;
@property (weak,nonatomic) LGNavigationSearchBar *fakeNav;

/** 图片轮播模型 */
@property (strong,nonatomic) NSArray *imageLoops;
@property (strong,nonatomic) NSArray *microModels;
@property (strong,nonatomic) NSArray *buildModels;
@property (strong,nonatomic) NSArray *digitalModels;

@property (assign,nonatomic) NSInteger currentIndex;

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
//    _swipeTableView.backgroundColor = [UIColor redColor];
//    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = NO;
    
    _swipeTableView.swipeHeaderView = self.header;
    _swipeTableView.swipeHeaderBar = self.segment;
    _swipeTableView.swipeHeaderTopInset = kNavHeight;
//    _swipeTableView.swipeHeaderBarScrollDisabled = YES;
    
    [self.view addSubview:_swipeTableView];
    
    /// 添加自定义导航栏
    LGNavigationSearchBar *fakeNav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    fakeNav.delegate = self;
    [self.view addSubview:fakeNav];
    _fakeNav = fakeNav;
    
    /// 模拟数据
    /// 微党课模拟数据
//    NSMutableArray *microModels  = [NSMutableArray array];
//    for (int i = 0; i < 4; i++) {
//        EDJMicroLessionAlbumModel *model = [EDJMicroLessionAlbumModel new];
//        if (i == 0) {
////            model.imgs = @[@"",@""];
//        }
//        model.classlist = @[[EDJMicroPartyLessionSubModel new],
//                            [EDJMicroPartyLessionSubModel new],
//                            [EDJMicroPartyLessionSubModel new]];
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
    
    /// TODO: 首页接口调试
    [DJNetworkManager homeIndexWithSuccess:^(id responseObj) {
        EDJHomeModel *homeModel = [EDJHomeModel mj_objectWithKeyValues:responseObj];
        self.imageLoops = homeModel.imageLoops;
        self.microModels = homeModel.microLessons;
        self.buildModels = homeModel.pointNews;
        self.digitalModels = homeModel.digitals;

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.swipeTableView reloadData];
        }];

    } failure:^(id failureObj) {
       NSLog(@"homeindexfailure -- %@",failureObj);

    }];
    /// TODO: 要闻列表加载更多???
    /// TODO: 数字阅读加载更多???
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedModel:) name:LGDidSelectedNotification object:nil];
}
#pragma mark - setter
- (void)setImageLoops:(NSArray *)imageLoops{
    _imageLoops = imageLoops;
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    [imageLoops enumerateObjectsUsingBlock:^(EDJHomeImageLoopModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [imgUrls addObject:model.classimg];
        NSLog(@"imgloop.classimg -- %@",model.classimg);
    }];
    _imgLoop.imageURLStringsGroup = imgUrls.copy;
}

#pragma mark - SwipeTableView M
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 3;
}
- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    CGRect rect = swipeView.bounds;
    rect.size.height -= kTabBarHeight ;
    if (index == 0) {
        HPMicrolessonView *tableview = [[HPMicrolessonView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableview.dataArray = self.microModels.copy;
        view = tableview;
        
    }else if (index == 1) {
        /// 返回党建要闻
        HPBuildTableView *tableview = [[HPBuildTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableview.dataArray = self.buildModels.copy;
        view = tableview;
        
    }else{
        /// 返回数字阅读
        rect.origin.y += 10;
        rect.size.height -= 10;
        HPDigitalCollectionView *collectionView = [[HPDigitalCollectionView alloc] initWithFrame:rect];
        
        collectionView.dataArray = self.digitalModels.copy;
        view = collectionView;
        
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

#pragma mark - LGSegmentControlDelegate
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click{
    [self.swipeTableView scrollToItemAtIndex:click animated:YES];
    _currentIndex = click;
}
#pragma mark - LGNavigationSearchBarDelelgate
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar{
    HPSearchViewController *searchVc = [HPSearchViewController new];
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
            /// TODO: 进入微党课详情，需要知道是音频，还是视频
            HPAudioVideoViewController *dvc = [HPAudioVideoViewController new];
            dvc.imgLoopModel = model;
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
            EDJMicroPartyLessionSubModel *lesson = alubm.classlist[subIndex];
            NSLog(@"EDJMicroPartyLessionSubModel -- %@",lesson);
            /// TODO: 进入微党课详情
            
            /// MARK: 进入微党课单条详情
            if ((index % 2) == 0) {
                /// 用于测试，第一个cell，打开视频详情
                HPAudioVideoViewController *avc = [HPAudioVideoViewController new];
                avc.contentType = ModelMediaTypeVideo;
                [self.navigationController pushViewController:avc animated:YES];
            }else{
                HPAudioVideoViewController *avc = [HPAudioVideoViewController new];
                avc.contentType = ModelMediaTypeAudio;
                [self.navigationController pushViewController:avc animated:YES];
            }
        }
            break;
        case LGDidSelectedSkipTypeMicrolessonAlbum:{
            /// MARK: 进入专辑列表
            HPAlbumTableViewController *album = [HPAlbumTableViewController new];
            [self.navigationController pushViewController:album animated:YES];
        }
            break;
        case LGDidSelectedSkipTypeBuildNews:{
            HPPartyBuildDetailViewController *dvc = [HPPartyBuildDetailViewController new];
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
- (CGFloat)topInsetHeight{
    return homeImageLoopHeight + homeSegmentHeight;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
