//
//  LIGMainTabBarController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LIGMainTabBarController.h"
#import "UIViewController+Extension.h"

#import "LGBaseViewController.h"// test

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
    
    // 暂未开放
    NSString *discoveryvcString = @"DJNotOpenViewController";
//    NSString *onlinevcString = @"DJNotOpenViewController";
    
//    NSString *discoveryvcString = @"EDJDiscoveryViewController";
    NSString *onlinevcString = @"EDJOnlineViewController";
    
    /// MARK: 配置自控制器
    NSArray<NSDictionary *> *childVcSettings = @[
  @{vcClassKey:@"HPChairmanSpeechViewController",
    vcTitleKey:@"讲习",
    tabbarIconKey:@"tab-icon-jiangxi-",
    tabbarSelectedIconKey:@"tab-icon-jiangxi-xz"
    },
  @{vcClassKey:discoveryvcString,
    vcTitleKey:@"发现",
    tabbarIconKey:@"tab-icon-faxian-",
    tabbarSelectedIconKey:@"tab-icon-faxian-xz"
    },
  @{vcClassKey:onlinevcString,
    vcTitleKey:@"在线",
    tabbarIconKey:@"tab-icon-zaixian-",
    tabbarSelectedIconKey:@"tab-icon-zaixian-xz"
    },
  @{vcClassKey:userCenterViewController,
    vcTitleKey:@"我的",
    tabbarIconKey:@"tab-icon-wode-",
    tabbarSelectedIconKey:@"tab-icon-wode-xz"
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
    

//    self.selectedIndex = 2;
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
    
    LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:vc];
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:normalIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
