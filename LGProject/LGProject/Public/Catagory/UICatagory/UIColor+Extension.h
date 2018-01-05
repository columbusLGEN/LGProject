//
//  UIColor+Extension.h
//  LGProject
//
//  Created by Peanut Lee on 2017/12/28.
//  Copyright © 2017年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 根据16进制字符串返回 颜色 eg: e3e3e3

 @param hexString 16进制字符串
 @return 目标颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
/**
 根据16进制字符串返回 颜色 eg: e3e3e3
 
 @param hexString 16进制字符串
 @param alpha 透明度
 @return 目标颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString withAlpha:(CGFloat)alpha;

/**
 根据0-255之间的数字返回 灰度色
 
 @param number x
 @return 目标颜色
 */
+ (UIColor *)lg_grayScaleWith:(CGFloat)number;

/**
 根据0-255之间的数字返回 灰度色

 @param number x
 @param alpha 透明度
 @return 目标颜色
 */
+ (UIColor *)lg_grayScaleWith:(CGFloat)number alpha:(CGFloat)alpha;
/// RGB alpha = 1
+ (UIColor *)lg_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 根绝 RGB 返回 颜色

 @param red R
 @param green G
 @param blue B
 @param alpha 透明度
 @return 目标颜色
 */
+ (UIColor *)lg_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/** 根据颜色生成UIImage */
- (UIImage *)imageByColor;

/** 生成随机颜色 */
+ (UIColor *)randomColor;

@end
