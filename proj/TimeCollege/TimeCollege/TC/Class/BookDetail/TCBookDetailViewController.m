//
//  TCBookDetailViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/25.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookDetailViewController.h"
#import "TCBookInfoTableViewController.h"
#import "TCBookDiscussViewController.h"
#import "LGTableViewController.h"
#import "TCBookInfoHeaderView.h"
#import "TCBookDetaileBookBottomView.h"

#define kOpenRefreshHeaderViewHeight 0

@interface TCBookDetailViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>


@end

@implementation TCBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self otherConfig];
}

- (void)otherConfig{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Public Function

+ (instancetype)bookinfovc {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.showBottomLine = YES;
    
    configration.lineColor = UIColor.TCColor_mainColor;
    configration.bottomLineBgColor = UIColor.YBColor_F3F3F3;
    configration.selectedItemColor = UIColor.TCColor_mainColor;
    configration.normalItemColor = UIColor.YBColor_6A6A6A;
    
    configration.lineWidthEqualFontWidth = YES;
    configration.lineHeight = 1;
    configration.lineBottomMargin = 10;
    
    TCBookDetailViewController *vc = [TCBookDetailViewController pageViewControllerWithControllers:[self getArrayVCs]
                                                                                            titles:[self getArrayTitles]
                                                                                            config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
    TCBookInfoHeaderView *headerView = [TCBookInfoHeaderView biHeader];
    headerView.frame = CGRectMake(0, 0, Screen_Width, 160);
    headerView.model = [NSObject new];
    
    /// ???
//    headerView.layer.contents = (id)[UIImage imageNamed:@"mine_header_bg"].CGImage;
    
    vc.headerView = headerView;
    /// 指定默认选择index 页面
    vc.pageIndex = 1;
    
    /// TODO 下拉刷新
//    __weak typeof(TCBookDetailViewController *) weakVC = vc;
    
//    vc.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        NSInteger refreshPage = weakVC.pageIndex;
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            /// 取到之前的页面进行刷新 pageIndex 是当前页面
//            LGTableViewController *vc2 = weakVC.controllersM[refreshPage];
//            [vc2.tableView reloadData];
//
//            if (kOpenRefreshHeaderViewHeight) {
//                weakVC.headerView.height = 300;
//                [weakVC.bgScrollView.mj_header endRefreshing];
//                [weakVC reloadSuspendHeaderViewFrame];
//            } else {
//                [weakVC.bgScrollView.mj_header endRefreshing];
//            }
//        });
//    }];
    return vc;
}

+ (NSArray *)getArrayVCs {
    /// 教材信息 vc
    TCBookInfoTableViewController *infovc = TCBookInfoTableViewController.new;
    /// 评价 vc
    TCBookDiscussViewController *disvc = TCBookDiscussViewController.new;
    
    return @[infovc,disvc];
}

+ (NSArray *)getArrayTitles {
    return @[@"教材信息", @"评价"];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    LGTableViewController *vc = pageViewController.controllersM[index];
    
    return vc.tableView;
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
//    NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
    
}

@end
