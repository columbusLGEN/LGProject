//
//  ECRBaseTableViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseTableViewController.h"
#import <UMAnalytics/MobClick.h>

@interface ECRBaseTableViewController ()

@end

@implementation ECRBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavLeftBackItem];
    [self updateSystemLanguage];
    
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self updateSystemLanguage];
    }];
    [self fk_observeNotifcation:kNotificationThemeChanged usingBlock:^(NSNotification *note) {
        [self updateSystemTheme];
    }];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@", [self class]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@", [self class]]];
}

- (void)updateSystemLanguage
{
    
}

- (void)updateSystemTheme
{
    
}

#pragma mark - 自定义导航栏返回按钮
- (void)createNavLeftBackItem {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(00, 0, 44, 44)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);// 设置内边距，以调整按钮位置
    [backButton setImage:[UIImage imageNamed:@"icon_arrow_left_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(baseViewControllerDismiss) forControlEvents:UIControlEventTouchUpInside];
//    [backButton sizeToFit];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    self.navigationItem.leftBarButtonItem = back;// 原写法导致其他控制器 添加 rightBarButtonItems 失败
    
    self.navigationItem.leftBarButtonItems = @[back];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;// 解决自定义导航栏按钮导致系统的左滑pop 失效
}

#pragma mark - 销毁控制器
- (void)baseViewControllerDismiss{
    switch (_viewControllerPushWay) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end


