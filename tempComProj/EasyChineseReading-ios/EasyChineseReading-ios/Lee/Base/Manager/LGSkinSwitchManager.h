//
//  LGSkinSwitchManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2018/1/3.
//  Copyright © 2018年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 首页切换皮肤通知 */
static NSString * const kNotificationChangeHomeUI = @"kNotificationChangeHomeUI";
static NSString * const kNotificationChangeHomeUIKey = @"kNotificationChangeHomeUIKey";

/** 皮肤类型 */
typedef NS_ENUM(NSUInteger, ECRHomeUIType) {
    ECRHomeUITypeDefault,
    ECRHomeUITypeAdultTwo,
    ECRHomeUITypeKidOne,
    ECRHomeUITypeKidtwo
};

@interface LGSkinSwitchManager : NSObject
/** 获取当前主题色 */
+ (UIColor *)currentThemeColor;
/** 返回当前主题色16进制字符串 */
+ (NSString *)currentThemeColorStr;
/** 获取当前主题色 少浅的颜色 */
+ (UIColor *)currentThemeFadeColor;
/** 获取当前用户皮肤 */
+ (ECRHomeUIType)getCurrentUserSkin;
/** 获取首页阴影颜色 */
+ (UIColor *)homeSkinShadowColor;
+ (UIColor *)homeBorderColor;

/**
 切换皮肤
 @param type 皮肤类型
 */
+ (void)changeSkinWithType:(ECRHomeUIType)type;
+ (instancetype)sharedInstance;
@end
