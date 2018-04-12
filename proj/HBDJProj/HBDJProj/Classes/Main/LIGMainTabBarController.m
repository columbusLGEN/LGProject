//
//  LIGMainTabBarController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LIGMainTabBarController.h"
#import "LIGBaseNavigationController.h"
#import "UIViewController+Extension.h"

#import "LIGBaseViewController.h"// test

static NSString * const vcClassKey = @"className";
static NSString * const vcTitleKey = @"vcTitle";
static NSString * const tabbarIconKey = @"tabbarIconKey";
static NSString * const tabbarSelectedIconKey = @"tabbarSelectedIconKey";
static NSString * const userCenterViewController = @"EDJUserCenterViewController";
static NSString * const ucStoryboard = @"UserCenter";
static NSString * const ucHomePageVcId = @"EDJUserCenterViewController";

@interface LIGMainTabBarController ()

@end

@implementation LIGMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// MARK: 配置自控制器
    NSArray<NSDictionary *> *childVcSettings = @[
  @{vcClassKey:@"EDJHomeViewController",
    vcTitleKey:@"讲习",
    tabbarIconKey:@"tabbar_icon_selected_home",
    tabbarSelectedIconKey:@"tabbar_icon_selected_home"
    },
  @{vcClassKey:@"EDJDiscoveryViewController",
    vcTitleKey:@"发现",
    tabbarIconKey:@"tabbar_icon_normal_discover",
    tabbarSelectedIconKey:@"tabbar_icon_normal_discover"
    },
  @{vcClassKey:@"EDJOnlineViewController",
    vcTitleKey:@"在线",
    tabbarIconKey:@"tabbar_icon_normal_online",
    tabbarSelectedIconKey:@"tabbar_icon_normal_online"
    },
  @{vcClassKey:userCenterViewController,
    vcTitleKey:@"个人中心",
    tabbarIconKey:@"tabbar_icon_normal_uc",
    tabbarSelectedIconKey:@"tabbar_icon_normal_uc"
    }
  ];
    for (NSInteger i = 0; i < childVcSettings.count; i++) {
        NSDictionary *vcSetting = childVcSettings[i];
        [self setChildViewControllerWithClassName:vcSetting[vcClassKey] title:vcSetting[vcTitleKey] normalIconName:vcSetting[tabbarIconKey] selectedIconName:vcSetting[tabbarSelectedIconKey]];
    }
    
    /// MARK: 设置tabbaritem选中字体颜色
    UITabBarItem *currentItem = [UITabBarItem appearance];
    NSMutableDictionary *textDict = [NSMutableDictionary dictionaryWithCapacity:10];
    textDict[NSForegroundColorAttributeName] = [UIColor EDJMainColor];
    [currentItem setTitleTextAttributes:textDict forState:UIControlStateSelected];
}

- (void)setChildViewControllerWithClassName:(NSString *)className title:(NSString *)title normalIconName:(NSString *)normalIconName selectedIconName:(NSString *)selectedIconName{
    NSString *info = [NSString stringWithFormat:@"%@ is not a kind of class UIViewController",className];
    UIViewController *vc;
    if ([className isEqualToString:userCenterViewController]) {
        vc = [self lgInstantiateViewControllerWithStoryboardName:ucStoryboard controllerId:ucHomePageVcId];
    }else{
        vc = [NSClassFromString(className) new];
    }
    
    /// isKindOfClass 是否是该类的实例,及其派生类的实例
    /// isMemberOfClass 是否是该类的实例
    NSAssert([vc isKindOfClass:[UIViewController class]], info);
    
    LIGBaseNavigationController *nav = [[LIGBaseNavigationController alloc] initWithRootViewController:vc];
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:normalIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
