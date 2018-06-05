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
#import "HPMicrolessonView.h"
#import "EDJMicroBuildModel.h"
#import "LGSegmentControl.h"
#import "LGNavigationSearchBar.h"

@interface HPHomeViewController ()<
SwipeTableViewDataSource
,SwipeTableViewDelegate
,SDCycleScrollViewDelegate
,LGNavigationSearchBarDelelgate>
@property (strong,nonatomic) SwipeTableView * swipeTableView;
@property (strong,nonatomic) SDCycleScrollView *imgLoop;
@property (strong,nonatomic) HPMicrolessonView *microlessonTableView;
@property (strong,nonatomic) LGSegmentControl *segment;
@property (weak,nonatomic) LGNavigationSearchBar *fakeNav;
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
    
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    _swipeTableView.swipeHeaderView = self.imgLoop;
    _swipeTableView.swipeHeaderBar = self.segment;
    _swipeTableView.swipeHeaderTopInset = kNavHeight;
    
    [self.view addSubview:_swipeTableView];
    
    /// 添加自定义导航栏
    LGNavigationSearchBar *fakeNav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    fakeNav.delegate = self;
    [self.view addSubview:fakeNav];
    _fakeNav = fakeNav;
}
#pragma mark - SwipeTableView M
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 3;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    HPMicrolessonView *tableview = [[HPMicrolessonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    tableview.backgroundColor = [UIColor orangeColor];
    NSMutableArray *microModels  = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        EDJMicroBuildModel *model = [EDJMicroBuildModel new];
        if (i == 0) {
            model.imgs = @[@"",@""];
        }
        [microModels addObject:model];
    }
    tableview.dataArray = microModels.copy;
    // 在没有设定下拉刷新宏的条件下，自定义的下拉刷新需要做 refreshheader 的 frame 处理
//    [self configRefreshHeaderForItem:view];
    view = tableview;
    return view;
}

#pragma mark - getter
- (SDCycleScrollView *)imgLoop{
    if (_imgLoop == nil) {
        _imgLoop = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 233)];
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
    }
    return _segment;
}


@end
