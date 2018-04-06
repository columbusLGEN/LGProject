//
//  LIGMainTabBarController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LIGMainTabBarController.h"
#import "LIGBaseNavigationController.h"

@interface LIGMainTabBarController ()

@end

@implementation LIGMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *vc = [NSClassFromString(@"EDJHomeViewController") new];
    LIGBaseNavigationController *nav = [[LIGBaseNavigationController alloc] initWithRootViewController:vc];
    vc.title = @"测试";
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
