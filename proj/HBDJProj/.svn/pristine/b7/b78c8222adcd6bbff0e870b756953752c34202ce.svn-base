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
    /// 第一个字符串的 #去掉,否则以#分割后的数组中第一个元素为 ""
    NSArray *colorHexStrings = [[self allHexStrings] componentsSeparatedByString:@"#"];
    NSInteger number = arc4random_uniform((int)colorHexStrings.count);/// 0-count 随机数字
    NSString *hex = colorHexStrings[number];
    return [self colorWithHexString:hex];
}

+ (NSString *)allHexStrings{
    return @"2980b9\
    #95a5a6\
    #2c3e50\
    #fbc531\
    #7f8fa6\
    #b2bec3\
    #2f3542\
    #57606f\
    #747d8c\
    #1e90ff\
    #ff6b81\
    #303952\
    #f8a5c2\
    #CAD3C8\
    #33d9b2\
    #1dd1a1\
    #535c68\
    #c7ecee\
    #0097e6\
    #C7C7C7\
    #CCCCCC\
    #00B2EE\
    #FF6461\
    #1abc9c\
    #16a085\
    #2ecc71\
    #27ae60\
    #3498db\
    #2980b9\
    #9b59b6\
    #8e44ad\
    #34495e\
    #f1c40f\
    #f39c12\
    #e67e22\
    #d35400\
    #e74c3c\
    #c0392b\
    #ecf0f1\
    #bdc3c7\
    #7f8c8d\
    #55efc4\
    #00b894\
    #81ecec\
    #00cec9\
    #74b9ff\
    #0984e3\
    #a29bfe\
    #6c5ce7\
    #dfe6e9\
    #ffeaa7\
    #fdcb6e\
    #fab1a0\
    #e17055\
    #ff7675\
    #d63031\
    #fd79a8\
    #e84393\
    #636e72\
    #2d3436\
    #f6e58d\
    #f9ca24\
    #ffbe76\
    #f0932b\
    #ff7979\
    #eb4d4b\
    #badc58\
    #6ab04c\
    #dff9fb\
    #c7ecee\
    #7ed6df\
    #22a6b3\
    #e056fd\
    #be2edd\
    #686de0\
    #4834d4\
    #30336b\
    #130f40\
    #95afc0\
    #4b6584"
    ;
}

@end
