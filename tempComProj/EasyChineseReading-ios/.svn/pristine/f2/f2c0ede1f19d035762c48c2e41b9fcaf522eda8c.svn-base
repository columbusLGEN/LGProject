//
//  UOrderVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserOrderVC.h"

#import "UOrderListViewController.h"
#import "UserLeaseVC.h"

@interface UserOrderVC ()

@property (strong, nonatomic) UOrderListViewController *orderListVC; // 订单详情
@property (strong, nonatomic) UserLeaseVC *leaseVC; // 包月

@property (strong, nonatomic) ZSegment *segment;

@end

@implementation UserOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 关闭右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"我的订阅");
    self.view.backgroundColor = [UIColor whiteColor];
}

/** 是否租阅订单，如果是租阅订单则直接展示包月列表，不是则展示订单列表 */
- (void)setIsLeaseOrder:(BOOL)isLeaseOrder
{
    _isLeaseOrder = isLeaseOrder;
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"图书") rightTitle:LOCALIZATION(@"包月") selectedIndex:_isLeaseOrder];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        [weakself.view bringSubviewToFront:weakself.orderListVC.view];
    };
    _segment.selectedRight = ^{
        [weakself.view bringSubviewToFront:weakself.leaseVC.view];
    };
    
    if (_isLeaseOrder) {
        [self configOrderView];
        [self configLeaseView];
    }
    else {
        [self configLeaseView];
        [self configOrderView];
    }
}

- (void)baseViewControllerDismiss
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 展示订单 包月

/** 包月 */
- (void)configLeaseView {
    _leaseVC = [UserLeaseVC loadFromStoryBoard:@"User"];
    _leaseVC.view.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44);
    
    [self addChildViewController:_leaseVC];
    [self.view addSubview:_leaseVC.view];
}

/** 订单 */
- (void)configOrderView {
    _orderListVC = [UOrderListViewController new];
    _orderListVC.view.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44);
    
    [self addChildViewController:_orderListVC];
    [self.view addSubview:_orderListVC.view];
}

@end
