//
//  LIGBaseNavigationController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseNavigationController.h"

@interface LGBaseNavigationController ()

@end

@implementation LGBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSettins];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)commonSettins{
    
    self.view.backgroundColor = [UIColor whiteColor];
    /// MARK: 设置tintColor (按钮颜色)
    self.navigationBar.tintColor = [UIColor blackColor];
    /// MARK: 设置导航栏字体颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /// MARK: 未知? -- TODO: 该属性的作用?
//    [self.navigationBar setTranslucent:YES];
    /// MARK: 设置导航栏背景色
//    [self.navigationBar setBarTintColor:[UIColor blueColor]];
    
    /// 返回按钮在 base view controller 中自定义
    
}

/// MARK: 重写push 方法 改变默认 push时底部tabBar的显示与隐藏
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        /// 当退出到根控制器时 显示底部 tabBar
        /// TODO: 登录注册控制器需要单独处理
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
