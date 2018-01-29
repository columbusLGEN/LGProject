//
//  UIColor+TOPColorSet.h
//  Top6000
//
//  Created by user on 16/10/24.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LGColor_78005e [UIColor colorR:0x78 g:00 b:0x5e a:1]

@interface UIColor (TOPColorSet)

/** 快速设置颜色 */
+ (instancetype)colorR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat) alpha;
// 灰度 色
+ (instancetype)colorWithRGB:(CGFloat)RGB alpha:(CGFloat)alpha;
//灰色，透明度1
+ (instancetype)grayColorFor:(CGFloat)number;
//透明度1
+ (instancetype)colorR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue;
// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;
//测试用，随机颜色
+ (instancetype)randomColor;
// 随机色站位图
+ (UIImage *)placeholderImageRandom;
@end
