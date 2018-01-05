//
//  UIView+Extension.h
//  LGProject
//
//  Created by Peanut Lee on 2017/12/28.
//  Copyright © 2017年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGSize  size;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGPoint origin;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

/** 设置随机背景色 */
- (void)randomBackgroundColor;

/**
 设置阴影
 
 @param shadowColor 阴影颜色
 @param shadowOffset 偏移量
 @param shadowOpacity 透明度
 @param shadowRadius 渐变读
 */
- (void)setShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(float)shadowRadius;

@end
