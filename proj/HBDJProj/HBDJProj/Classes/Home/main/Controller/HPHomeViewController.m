//
//  HPHomeViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPHomeViewController.h"
#import <SwipeTableView/SwipeTableView.h>
#import "HPMicrolessonViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LGSegmentControl.h"
#import "LGNavigationSearchBar.h"

#import "HPMicrolessonView.h"
#import "HPBuildTableView.h"
#import "HPDigitalCollectionView.h"
#import "EDJHomeDigitalsFlowLayout.h"
#import "EDJMicroBuildModel.h"
#import "EDJDigitalModel.h"

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

@property (strong,nonatomic) EDJHomeDigitalsFlowLayout *flowLayout;

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
    
    /// netdata
    /// 微党课模拟数据
    NSMutableArray *microModels  = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        EDJMicroBuildModel *model = [EDJMicroBuildModel new];
        if (i == 0) {
            model.imgs = @[@"",@""];
        }
        [microModels addObject:model];
    }
    /// 党建要闻模拟数据
    NSMutableArray *buildModels = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        EDJMicroBuildModel *model = [EDJMicroBuildModel new];
        model.showInteractionView = YES;
        NSMutableArray *imgs = [NSMutableArray new];
        int k = arc4random_uniform(3);
        if (k == 2) {
            k++;
        }
        for (int j = 0;j < k; j++) {
            [imgs addObject:@"build"];
        }
        model.imgs = imgs.copy;
        [buildModels addObject:model];
    }
    /// 数字阅读模拟数据
    NSMutableArray *digitalModels  = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        EDJDigitalModel *model = [EDJDigitalModel new];
        [digitalModels addObject:model];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.microModels = microModels.copy;
        self.buildModels = buildModels.copy;
        self.digitalModels = digitalModels.copy;
        [self.swipeTableView reloadData];
    });
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
        return view;
    }else if (index == 1) {
        /// 返回党建要闻
        HPBuildTableView *tableview = [[HPBuildTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableview.dataArray = self.buildModels.copy;
        view = tableview;
        return view;
    }else{
        /// 返回数字阅读
        rect.origin.y += 10;
        rect.size.height -= 10;
        HPDigitalCollectionView *collectionView = [[HPDigitalCollectionView alloc] initWithFrame:rect collectionViewLayout:self.flowLayout];
        
        collectionView.dataArray = self.digitalModels.copy;
        view = collectionView;
        return view;
    }
    
}

- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView{
    [self.segment elfAnimateWithIndex:swipeView.currentItemIndex];
}

#pragma mark - LGSegmentControlDelegate
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click{
    [self.swipeTableView scrollToItemAtIndex:click animated:YES];
    _currentIndex = click;
}

#pragma mark - getter
- (STHeaderView *)header{
    if (!_header) {
        _header = [[STHeaderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 233)];
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
        _imgLoop.imageURLStringsGroup = @[
                                          @"https://goss.vcg.com/creative/vcg/800/version23/VCG21gic13374057.jpg",
                                          @"http://dl.bizhi.sogou.com/images/2013/12/19/458657.jpg",
                                          @"https://goss3.vcg.com/creative/vcg/800/version23/VCG21gic19568254.jpg"];
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
- (EDJHomeDigitalsFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [EDJHomeDigitalsFlowLayout new];
    }
    return _flowLayout;
}

@end
