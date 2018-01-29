//
//  LGSkinSwitchManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2018/1/3.
//  Copyright © 2018年 retech. All rights reserved.
//

/**
 切换皮肤,首页需要改动的:
 * main背景图
 * 导航栏背景色 & 购物车图标
 * 分类图标
 * headline 图标 & 文字背景图 & 延长线
 * books 背景 & 圆角
 * tabbar 图标 & 背景色
 */

#import "LGSkinSwitchManager.h"

@implementation LGSkinSwitchManager

+ (UIColor *)currentThemeColor{
    switch ([self getCurrentUserSkin]) {
        case ECRHomeUITypeDefault:{
           return [UIColor cm_purpleColor_82056B_1];
        }
            break;
        case ECRHomeUITypeAdultTwo:{
            return [UIColor colorWithHexString:@"23a2c2"];
        }
            break;
        case ECRHomeUITypeKidOne:{
            return [UIColor colorWithHexString:@"72b848"];
        }
            break;
        case ECRHomeUITypeKidtwo:{
            return [UIColor colorWithHexString:@"23a2c2"];
        }
            break;
    }
}
+ (NSString *)currentThemeColorStr{
    switch ([self getCurrentUserSkin]) {
        case ECRHomeUITypeDefault:{
            return @"82056B";
        }
            break;
        case ECRHomeUITypeAdultTwo:{
            return @"23a2c2";
        }
            break;
        case ECRHomeUITypeKidOne:{
            return @"72b848	";
        }
            break;
        case ECRHomeUITypeKidtwo:{
            return @"23a2c2";
        }
            break;
    }
}
+ (UIColor *)currentThemeFadeColor{
    switch ([self getCurrentUserSkin]) {
        case ECRHomeUITypeDefault:{
            return [UIColor colorWithHexString:@"fbf7ff"];
        }
            break;
        case ECRHomeUITypeAdultTwo:{
            return [UIColor colorWithHexString:@"f7fdff"];
        }
            break;
        case ECRHomeUITypeKidOne:{
            return [UIColor colorWithHexString:@"f4ffed"];
        }
            break;
        case ECRHomeUITypeKidtwo:{
            return [UIColor colorWithHexString:@"f7fdff"];
        }
            break;
    }
}
+ (UIColor *)homeBorderColor{
    return [UIColor colorWithHexString:@"e3e3e3"];
}
/** 获取当前用户皮肤 */
+ (ECRHomeUIType)getCurrentUserSkin{
    return [[self sharedInstance] getCurrentUserSkin];
}
/** 获取当前用户皮肤 */
- (ECRHomeUIType)getCurrentUserSkin{
    NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:self.localSkinKey];
    return type.integerValue;
}
/** 切换皮肤 */
+ (void)changeSkinWithType:(ECRHomeUIType)type{
    [[self sharedInstance] changeSkinWithType:type];
}
/** 切换皮肤 */
- (void)changeSkinWithType:(ECRHomeUIType)type{
    NSNumber *homeUIType = @(type);
    NSDictionary *dict = @{kNotificationChangeHomeUIKey:homeUIType};
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeHomeUI object:nil userInfo:dict];
    /// 保存本次修改结果
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:self.localSkinKey];
}
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
/** 获取首页阴影颜色 */
+ (UIColor *)homeSkinShadowColor{
    return [UIColor colorWithHexString:@"ad7c14"];
}
/** 获取本地皮肤键 */
- (NSString *)localSkinKey{
    return [NSString stringWithFormat:@"lg_skin_type"];
}
@end
