//
//  TCMainTabBarController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/12.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMainTabBarController.h"
#import "TCMyBookrackViewController.h"
#import "TCSchoolBookPageViewController.h"
#import "LGBaseNavigationController.h"

@interface TCMainTabBarController ()

@end

@implementation TCMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatChildViewControllerWith:[TCMyBookrackViewController new] title:@"我的书橱" iconNormal:@"icon_tb_unselected_my" iconSelect:@"icon_tb_selected_my"];

    [self creatChildViewControllerWith:[TCSchoolBookPageViewController bookpagevc] title:@"学校书橱" iconNormal:@"icon_tb_unselected_school" iconSelect:@"icon_tb_selected_school"];
    
    self.selectedIndex = 1;
}

- (void)creatChildViewControllerWith:(UIViewController *)vc title:(NSString *)title iconNormal:(NSString *)iconNormal iconSelect:(NSString *)iconSelect{
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:iconNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:iconSelect] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:vc];
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2.5)];
    //    [nav.tabBarItem setImageInsets:UIEdgeInsetsMake(-5, 0, 5, 0)];
    [self addChildViewController:nav];
}

@end
