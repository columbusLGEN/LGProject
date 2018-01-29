//
//  UIColor+TOPColorSet.m
//  Top6000
//
//  Created by user on 16/10/24.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "UIColor+TOPColorSet.h"

@implementation UIColor (TOPColorSet)

+ (instancetype)colorR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat) alpha{
    return [UIColor colorWithRed:red/0xff green:green/0xff blue:blue/0xff alpha:alpha];
}

+ (instancetype)colorWithRGB:(CGFloat)RGB alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:RGB/0xff green:RGB/0xff blue:RGB/0xff alpha:alpha];
}

+ (instancetype)grayColorFor:(CGFloat)number {
    
    return [self colorWithRGB:number alpha:1];
}

+ (instancetype)colorR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue {
    
    return [self colorR:red g:green b:blue a:1];
}

+ (instancetype)randomColor {
    return [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255. blue:arc4random()%255/255. alpha:1];
}

+ (UIImage *)placeholderImageRandom{
    UIColor *color;
    NSInteger number = arc4random_uniform(16);
    switch (number) {
        case 0:
            color = [UIColor colorR:0x98 g:0x8a b:0x22 a:1];// 988a22
            break;
        case 1:
            color = [UIColor colorR:0x5e g:0x9f b:0x32 a:1];// 5e9f32
            break;
        case 2:
            color = [UIColor colorR:0xe5 g:0xd9 b:0x9a a:1];// e5d99a
            break;
        case 3:
            color = [UIColor colorR:0xd5 g:0xcd b:0xc5 a:1];// d5cdc5
            break;
        case 4:
            color = [UIColor colorR:0xe4 g:0xcc b:0x96 a:1];// e4cc96
            break;
        case 5:
            color = [UIColor colorR:0xec g:0xbf b:0xb2 a:1];// ecbfb2
            break;
        case 6:
            color = [UIColor colorR:0x4e g:0x4c b:0x3a a:1];// 4e4c3a
            break;
        case 7:
            color = [UIColor colorR:0xe2 g:0xd7 b:0x9c a:1];// e2d79c
            break;
        case 8:
            color = [UIColor colorR:0x5d g:0x57 b:0x44 a:1];// 5d5744
            break;
        case 9:
            color = [UIColor colorR:0x50 g:0x6a b:0x5a a:1];// 506a5a
            break;
        case 10:
            color = [UIColor colorR:0xcf g:0xa2 b:0x26 a:1];// cfa226
            break;
        case 11:
            color = [UIColor colorR:0x2b g:0x8a b:0xd5 a:1];// 2b8ad5
            break;
        case 12:
            color = [UIColor colorR:0xca g:0xa9 b:0x7f a:1];// caa97f
            break;
        case 13:
            color = [UIColor colorR:0x94 g:0xaa b:0x8c a:1];// 94aa8c
            break;
        case 14:
            color = [UIColor colorR:0x9e g:0xb1 b:0xb0 a:1];// 9eb1b0
            break;
        case 15:
            color = [UIColor colorR:0xd6 g:0xc6 b:0xaf a:1];// d6c6af
            break;

    }
    return [self imageWithColor:color rect:CGRectZero];
}

+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect{
    // 描述矩形
    if (CGRectEqualToRect(rect, CGRectZero)) {
        rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    }
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
