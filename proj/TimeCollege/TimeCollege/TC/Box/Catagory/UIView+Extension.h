//
//  UIView+Extension.h
//  LGProject
//
//  Created by Peanut Lee on 2017/12/28.
//  Copyright © 2017年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 设置指定方向边框
 
 @param hasTopBorder 上
 @param hasLeftBorder 左
 @param hasBottomBorder 下
 @param hasRightBorder 右
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)setDirectionBorderWithTop:(BOOL)hasTopBorder left:(BOOL)hasLeftBorder bottom:(BOOL)hasBottomBorder right:(BOOL)hasRightBorder borderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth;

/**
 设置阴影
 
 @param shadowColor 阴影颜色
 @param shadowOffset 偏移量
 @param shadowOpacity 透明度
 @param shadowRadius 渐变读
 */
- (void)setShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(float)shadowRadius;

/**
 设置border & 圆角

 @param width 边框宽度
 @param borderColor 边框颜色
 @param cornerRadius 圆角弧度
 */
- (void)cutBorderWithBorderWidth:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;

/// MARK: 切圆形
- (void)cutToCycle;

@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGSize  size;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGPoint origin;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

@end
