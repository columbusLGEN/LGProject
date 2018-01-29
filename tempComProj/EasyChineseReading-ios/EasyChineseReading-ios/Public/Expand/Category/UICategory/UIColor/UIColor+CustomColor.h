//
//  UIColor+CustomColor.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(CustomColor)

/*
 项目主题颜色；
 */
+ (UIColor *)cm_mainColor;

/*
 自定义颜色      cm_xxxColor_XXXXXX_X
 xxxColor:     颜色的趋近颜色 或者 功能颜色
 XXXXXX:       颜色值 0000000-FFFFFF
 X             透明度 0F-1
 */

// ------------ 趋近颜色 ------------

+ (UIColor *)cm_whiteColor_E7E7E7_1;
+ (UIColor *)cm_whiteColor_FFFFFF_1F;
+ (UIColor *)cm_whiteColor_FFFFFF_7F;

+ (UIColor *)cm_purpleColor_82056B_1;

+ (UIColor *)cm_orangeColor_FF5910_1;
+ (UIColor *)cm_orangeColor_F2C782_1;
+ (UIColor *)cm_orangeColor_BB7435_1; // 包月续费
+ (UIColor *)cm_orangeColor_FF7200_1;
+ (UIColor *)cm_orangeColor_FFAF04_1;
+ (UIColor *)cm_orangeColor_FF8400_1;

+ (UIColor *)cm_blackColor_333333_1;
+ (UIColor *)cm_blackColor_666666_1;
+ (UIColor *)cm_blackColor_000000_2F;
+ (UIColor *)cm_blackColor_000000_5F;

+ (UIColor *)cm_greenColor_21C0AE_1;

+ (UIColor *)cm_grayColor__807F7F_1;
+ (UIColor *)cm_grayColor__F1F1F1_1;
+ (UIColor *)cm_grayColor__F8F8F8_1;

+ (UIColor *)cm_yellowColor_FFE402_1;
+ (UIColor *)cm_yellowColor_FFAF04_1;

+ (UIColor *)cm_lineColor_D9D7D7_1;
+ (UIColor *)cm_placeholderColor_C7C7CD_1;


@end
