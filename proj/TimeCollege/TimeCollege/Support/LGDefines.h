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

static CGFloat LGNavBarButtonHeight = 30;
static CGFloat marginEight = 8;
static CGFloat marginFifteen = 15;
static CGFloat marginTen = 10;
static CGFloat marginFive = 5;

/// MARK: UUID
#define kLGUUID [[UIDevice currentDevice] identifierForVendor].UUIDString

// MARK: Zup_添加 kHeigh_ScreedWidth9_16
/// MARK:屏幕宽度的16分之9，常用图片比例的高度
#define kLGHeigh_ScreedWidth9_16 ([UIScreen mainScreen].bounds.size.width)*9/16.f
/// MARK:屏幕宽度
#define Screen_Width ([UIScreen mainScreen].bounds.size.width)
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
#define kLGNavHeight (([[UIScreen mainScreen] bounds].size.height >= 812) ? 88 : 64)
///MARK:导航栏高度(不包括状态栏)
#define kLGNavSingleBarHeight 44
///MARK:状态栏高度
#define kLGStatusBarHeight (([[UIScreen mainScreen] bounds].size.height == 812) ? 44 : 20)
/// MARK:tabBar 高度
#define kLGTabBarHeight (([[UIScreen mainScreen] bounds].size.height == 812) ? 83 : 49)

#define kLGNavArrowLeft      @"arrow_left"
#define kLGNavArrowLeftWhite @"icon_arrow_left_white"

#define LGPlaceholderImage [UIImage imageNamed:@""]

#define kUploadFileTypeImageJpeg            @"image/jpeg"
#define kUploadFileTypeVidepMp4             @"video/mp4"

#define kNoticeWordNoData            @"暂无数据"
#define kNoticeWordNoMoreData        @"暂无更多数据"
#define kNoticeWordNetLost           @"连接失败，请检查您的网络"
#define kNoticeWordSearchEmpty       @"哎呦，没有找到你想要的"
