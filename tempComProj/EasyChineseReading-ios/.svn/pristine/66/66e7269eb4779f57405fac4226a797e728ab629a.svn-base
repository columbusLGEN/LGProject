//
//  CLMNavigationController.m
//  Pandora
//
//  Created by lee on 2017/7/17.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "CLMNavigationController.h"
#import "UIImage+LEEImageExtension.h"
#import "UIColor+TOPColorSet.h"
#import "LoginVC.h"
#import "RegisterVC.h"
#import "RegisterSuccessVC.h"

@interface CLMNavigationController ()

@end

@implementation CLMNavigationController

// MARK: 重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count && (![viewController isKindOfClass:[RegisterVC class]] &&
                                            ![viewController isKindOfClass:[RegisterSuccessVC class]] &&
                                            ![viewController isKindOfClass:[LoginVC class]])) {// 当退出到根控制器时不隐藏
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    // 设置导航栏标题字体颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self.navigationBar setTranslucent:NO];
    
    self.navigationBar.barTintColor = [LGSkinSwitchManager currentThemeColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
