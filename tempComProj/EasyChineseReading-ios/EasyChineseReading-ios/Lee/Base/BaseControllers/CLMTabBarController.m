//
//  CLMTabBarController.m
//  Pandora
//
//  Created by lee on 2017/7/17.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "CLMTabBarController.h"
#import "CLMNavigationController.h"
#import "ECRHome.h"

@interface CLMTabBarController ()
/** 测试用 */
@property (assign,nonatomic) NSInteger switchNumber;

@end

@implementation CLMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSetting];
//    NSLog(@"%@",self.tabBar);
    // TEST
    
    [self fk_observeNotifcation:kNotificationSelectHome usingBlock:^(NSNotification *note) {
        self.selectedIndex = 0;
    }];
    [self fk_observeNotifcation:kNotificationSelectUser usingBlock:^(NSNotification *note) {
        self.selectedIndex = 2;
    }];
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self baseSetting];
    }];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)baseSetting{
    [self clmSetChildViewControllerWith:
     (UIViewController *)[[NSClassFromString(@"ECRHomeViewController") alloc] init]
                                  title:LOCALIZATION(@"书城")
                               iconName:@"icon_tabbar_selected_bookstore"
                             iconSeName:@"icon_tabbar_unSelected_bookstore"];
    [self clmSetChildViewControllerWith:
     (UIViewController *)[[NSClassFromString(@"ECRBookRackController") alloc] init]
                                  title:LOCALIZATION(@"书架")
                               iconName:@"icon_tabbar_selected_bookshelf"
                             iconSeName:@"icon_tabbar_unSelected_bookshelf"];
    [self clmSetChildViewControllerWith:
//     (UIViewController *)[[NSClassFromString(@"UCRecommendManageVC") alloc] init]
          (UIViewController *)[[NSClassFromString(@"UserViewController") alloc] init]
                                  title:LOCALIZATION(@"我")
                               iconName:@"icon_tabbar_selected_user"
                             iconSeName:@"icon_tabbar_unSelected_user"];
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    NSMutableDictionary *textDict = [NSMutableDictionary dictionaryWithCapacity:10];
    textDict[NSForegroundColorAttributeName] = [UIColor cm_mainColor];
    [tabBarItem setTitleTextAttributes:textDict forState:UIControlStateSelected];
}

- (void)clmSetChildViewControllerWith:(UIViewController *)vc title:(NSString *)title iconName:(NSString *)iconName iconSeName:(NSString *)iconSeName{
    vc.title = title;
//    NSLog(@"tabbartitle -- %@",title);
    vc.tabBarItem.image = [[UIImage imageNamed:iconSeName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CLMNavigationController *nav = [[CLMNavigationController alloc] initWithRootViewController:vc];
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, - 2.5)];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    // 切换tabbar时,通知首页
    [[NSNotificationCenter defaultCenter] postNotificationName:ECRHomeSwitchAniNotification object:nil];
    
}

//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



@end
