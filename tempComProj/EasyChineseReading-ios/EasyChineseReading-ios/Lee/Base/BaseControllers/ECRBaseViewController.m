//
//  ECRBaseViewController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"
#import <UMAnalytics/MobClick.h>

@interface ECRBaseViewController ()

@end

@implementation ECRBaseViewController
//
//- (id)init {
//    if (self == [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotfication:) name:kNotificationThemeChanged object:nil];
//    }
//    [self reloadThemeImage];
//    return self;
//}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavLeftBackItem];
    [self setupObserver];
//    [self reloadThemeImage];
    
    [self updateSystemLanguage];
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self updateSystemLanguage];
    }];
    [self fk_observeNotifcation:kNotificationThemeChanged usingBlock:^(NSNotification *note) {
        [self updateSystemTheme];
    }];
    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
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
- (void)createNavLeftBackItem{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
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

#pragma mark 更换主题

//- (void)themeChangedNotfication:(NSNotification *)notification
//{
//    [self reloadThemeImage];
//}

//- (void)reloadThemeImage {
//    ThemeManager *themeManager = [ThemeManager sharedThemeManager];
    
//    UIImage *navigationBackgroundImage = [themeManager themeImageWithName:@"navigationbar_background.png"];
//    [self.navigationController.navigationBar setBackgroundImage:navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
//
//    UIImage *tabBarBackgroundImage = [themeManager themeImageWithName:@"tabbar_background.png"];
//    [self.tabBarController.tabBar setBackgroundImage:tabBarBackgroundImage];
//}

// --------中英文切换
- (void)textDependsLauguage{
    
}
- (void)setupObserver{
    [self textDependsLauguage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDependsLauguage) name:LGPChangeLanguageNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
