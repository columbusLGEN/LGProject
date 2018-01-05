//
//  UIColor+Extension.m
//  LGProject
//
//  Created by Peanut Lee on 2017/12/28.
//  Copyright © 2017年 LG. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

/// 16进制
+ (UIColor *)colorWithHexString:(NSString *)hexString{
    return [UIColor colorWithHexString:hexString withAlpha:1.0];
}
/// 16进制A
+ (UIColor *)colorWithHexString:(NSString *)hexString withAlpha:(CGFloat)alpha{
    if ( !hexString ) {
        return nil;
    }
    uint value = 0;
    if ( [hexString hasPrefix:@"#"] ) // #FFF
    {
        hexString = [hexString substringFromIndex:1];
    }
    value = (uint)strtol(hexString.UTF8String , nil, 16);
    // alpha
    // clip to bounds
    alpha = MIN(MAX(0.0, alpha), 1.0);
    uint alphaByte = (uint) (alpha * 255.0);
    value |= (alphaByte << 24);
    return [UIColor colorWithARGBValue:value];
}

/// 灰度色(RBG值相等的颜色)
+ (UIColor *)lg_grayScaleWith:(CGFloat)number{
    return [UIColor lg_grayScaleWith:number alpha:1];
}
/// 灰度色 A
+ (UIColor *)lg_grayScaleWith:(CGFloat)number alpha:(CGFloat)alpha{
    return [UIColor lg_colorWithRed:number green:number blue:number alpha:alpha];
}
/// RGB alpha = 1
+ (UIColor *)lg_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    return [UIColor lg_colorWithRed:red green:green blue:blue alpha:1];
}
/// RGBA
+ (UIColor *)lg_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/0xFF green:green/0xFF blue:blue/0xFF alpha:alpha];
}
+ (UIColor *)colorWithARGBValue:(uint)value{
    uint a = (value & 0xFF000000) >> 24;
    uint r = (value & 0x00FF0000) >> 16;
    uint g = (value & 0x0000FF00) >> 8;
    uint b = (value & 0x000000FF);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

- (UIImage *)imageByColor{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [self CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255. blue:arc4random()%255/255. alpha:1];
}

@end
