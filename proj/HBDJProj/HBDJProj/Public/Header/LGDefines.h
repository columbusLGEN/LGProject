//
//  LGDefines.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// MARK:屏幕宽度
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
/// MARK:屏幕高度
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
/// MARK:屏幕bounds
#define kScreenBounds ([UIScreen mainScreen].bounds)
///MARK:APP对象 （单例对象）
#define kApplication [UIApplication sharedApplication]
///MARK:主窗口 （keyWindow）
#define kKeyWindow [UIApplication sharedApplication].keyWindow
///MARK:APP对象的delegate
#define kAppDelegate [UIApplication sharedApplication].delegate
///MARK:NSUserDefaults实例化
#define kUserDefaults [NSUserDefaults standardUserDefaults]
///MARK:通知中心 （单例对象）
#define kNotificationCenter [NSNotificationCenter defaultCenter]
///MARK:导航栏高度
#define kNavHeight (([[UIScreen mainScreen] bounds].size.height == 812) ? 88 : 64)
/// MARK:tabBar 高度
#define kTabBarHeight (([[UIScreen mainScreen] bounds].size.height == 812) ? 83 : 49)
///MARK:RELEASE模式不打印
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif


