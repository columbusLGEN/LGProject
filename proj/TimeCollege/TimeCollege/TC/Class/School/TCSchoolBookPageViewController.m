//
//  TCSchoolBookPageViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/8.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCSchoolBookPageViewController.h"
#import "LGTableViewController.h"
#import "TCSchoolBookTableViewController.h"
#import "UIViewController+LGExtension.h"
#import "TCSearchViewController.h"

@interface TCSchoolBookPageViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@end

@implementation TCSchoolBookPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self otherConfig];
}

/** 搜索 */
- (void)searchMyBookrack{
    TCSearchViewController *searchvc = TCSearchViewController.new;
    searchvc.blrType = 1;
    [self.navigationController pushViewController:searchvc animated:YES];
}

- (void)otherConfig{
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    [self addNavSearch];
}

#pragma mark - Public Function

+ (instancetype)bookpagevc {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleTop;
//    configration.headerViewCouldScale = YES;
//    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.menuWidth = 160;

    configration.lineColor = UIColor.TCColor_mainColor;
    configration.selectedItemColor = UIColor.TCColor_mainColor;
    configration.normalItemColor = UIColor.YBColor_6A6A6A;
    
    configration.lineWidthEqualFontWidth = YES;
    configration.lineHeight = 1;
    configration.lineBottomMargin = 1;

    TCSchoolBookPageViewController *vc = [TCSchoolBookPageViewController pageViewControllerWithControllers:[self getArrayVCs]
                                                                                            titles:[self getArrayTitles]
                                                                                            config:configration];
    vc.dataSource = vc;
    vc.delegate = vc;
    
//    TCBookInfoHeaderView *headerView = [TCBookInfoHeaderView biHeader];
//    headerView.frame = CGRectMake(0, 0, Screen_Width, 160);
//    headerView.model = [NSObject new];
//    
//    /// ???
//    //    headerView.layer.contents = (id)[UIImage imageNamed:@"mine_header_bg"].CGImage;
//    
//    vc.headerView = headerView;
//    /// 指定默认选择index 页面
//    vc.pageIndex = 1;
    
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
    /// 数字教材 vc
    TCSchoolBookTableViewController *digvc = TCSchoolBookTableViewController.new;
    /// 电子图书 vc
    TCSchoolBookTableViewController *ebookvc = TCSchoolBookTableViewController.new;
    
    return @[digvc,ebookvc];
}

+ (NSArray *)getArrayTitles {
    return @[@"数字教材", @"电子图书"];
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
