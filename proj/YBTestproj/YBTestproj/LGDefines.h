//
//  LGDefines.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// MARK: 打印
//#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
//#define debugMethod() NSLog(@"%s", __func__)
//#else
//#define NSLog(...)
//#define debugMethod()
//#endif

// MARK: Zup_添加 kHeigh_ScreedWidth9_16
/// MARK:屏幕宽度的16分之9，常用图片比例的高度
#define kLGHeigh_ScreedWidth9_16 ([UIScreen mainScreen].bounds.size.width)*9/16.f
/// MARK:屏幕宽度
#define kLGScreenWidth ([UIScreen mainScreen].bounds.size.width)
/// MARK:屏幕高度
#define kLGScreenHeight ([UIScreen mainScreen].bounds.size.height)
/// MARK:屏幕bounds
#define kLGScreenBounds ([UIScreen mainScreen].bounds)
///MARK:APP对象 （单例对象）
#define kLGApplication [UIApplication sharedApplication]
///MARK:主窗口 （keyWindow）
#define kLGKeyWindow [UIApplication sharedApplication].keyWindow
///MARK:APP对象的delegate
#define kLGAppDelegate [UIApplication sharedApplication].delegate
///MARK:NSUserDefaults实例化
#define kLGUserDefaults [NSUserDefaults standardUserDefaults]
///MARK:通知中心 （单例对象）
#define kLGNotificationCenter [NSNotificationCenter defaultCenter]
///MARK:导航栏高度(包括状态栏)
#define kLGNavHeight (([[UIScreen mainScreen] bounds].size.height == 812) ? 88 : 64)
///MARK:导航栏高度(不包括状态栏)
#define kLGNavSingleBarHeight 44
///MARK:状态栏高度
#define kLGStatusBarHeight (([[UIScreen mainScreen] bounds].size.height == 812) ? 44 : 20)
/// MARK:tabBar 高度
#define kLGTabBarHeight (([[UIScreen mainScreen] bounds].size.height == 812) ? 83 : 49)

//#define DJPlaceholderImage [UIImage imageNamed:@"dj_placeholder"]
//#define DJDigitalBookPImage [UIImage imageNamed:@"home_book_placeholder"]
//#define DJImgloopPImage [UIImage imageNamed:@"home_imgloop_placeholder"]
//#define DJHeadIconPImage [UIImage imageNamed:@"dj_head_icon_placeholder"]



