//
//  UIColor+CustomColor.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor(CustomColor)

+ (UIColor *)cm_mainColor
{
    return [LGSkinSwitchManager currentThemeColor];
//    return [self cm_purpleColor_82056B_1];
}

#pragma mark -
#pragma mark 趋近色

+ (UIColor *)cm_whiteColor_E7E7E7_1
{
    return [UIColor colorWithHexString:@"E7E7E7"];
}

+ (UIColor *)cm_whiteColor_FFFFFF_1F
{
    return [UIColor colorWithHexString:@"FFFFFF" withAlpha:0.1f];
}

+ (UIColor *)cm_whiteColor_FFFFFF_7F
{
    return [UIColor colorWithHexString:@"FFFFFF" withAlpha:0.7f];
}

+ (UIColor *)cm_purpleColor_82056B_1
{
    return [UIColor colorWithHexString:@"82056B"];
}

+ (UIColor *)cm_lineColor_D9D7D7_1
{
    return [UIColor colorWithHexString:@"D9D7D7"];
}

+ (UIColor *)cm_orangeColor_FF5910_1
{
    return [UIColor colorWithHexString:@"FF5910"];
}

+ (UIColor *)cm_orangeColor_FFAF04_1
{
    return [UIColor colorWithHexString:@"FFAF04"];
}

+ (UIColor *)cm_orangeColor_BB7435_1 // 包月续费
{
    return [UIColor colorWithHexString:@"BB7435"];
}

+ (UIColor *)cm_orangeColor_FF8400_1
{
    return [UIColor colorWithHexString:@"FF8400"];
}

+ (UIColor *)cm_blackColor_333333_1
{
    return [UIColor colorWithHexString:@"333333"];
}

+ (UIColor *)cm_blackColor_666666_1
{
    return [UIColor colorWithHexString:@"666666"];
}

+ (UIColor *)cm_blackColor_000000_2F
{
    return [UIColor colorWithHexString:@"000000" withAlpha:.2f];
}

+ (UIColor *)cm_blackColor_000000_5F
{
    return [UIColor colorWithHexString:@"000000" withAlpha:.5f];
}

+ (UIColor *)cm_greenColor_21C0AE_1
{
    return [UIColor colorWithHexString:@"21C0AE"];
}

+ (UIColor *)cm_grayColor__807F7F_1
{
    return [UIColor colorWithHexString:@"807F7F"];
}

+ (UIColor *)cm_grayColor__F1F1F1_1
{
    return [UIColor colorWithHexString:@"F1F1F1"];
}

+ (UIColor *)cm_grayColor__F8F8F8_1
{
    return [UIColor colorWithHexString:@"F8F8F8"];
}

+ (UIColor *)cm_orangeColor_F2C782_1
{
    return [UIColor colorWithHexString:@"F2C782"];
}

+ (UIColor *)cm_orangeColor_FF7200_1
{
    return [UIColor colorWithHexString:@"FF7200"];
}

+ (UIColor *)cm_yellowColor_FFE402_1
{
    return [UIColor colorWithHexString:@"FFE402"];
}

+ (UIColor *)cm_yellowColor_FFAF04_1
{
    return [UIColor colorWithHexString:@"FFAF04"];
}

+ (UIColor *)cm_placeholderColor_C7C7CD_1
{
    return [UIColor colorWithHexString:@"C7C7CD"];
}

@end
