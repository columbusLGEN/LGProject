//
//  UIView+Extension.h
//  HaoWeibo
//
//  Created by 张仁昊 on 16/3/9.
//  Copyright © 2016年 张仁昊. All rights reserved.
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

// 判断view是否显示在屏幕上
- (BOOL)isDisplayedInScreen;

// test 测试用
- (void)randomBackgroundColor;

// 取消所有响应
- (void)resignAllFirstResponder;

/**
 设置阴影
 
 @param shadowColor 阴影颜色
 @param shadowOffset 偏移量
 @param shadowOpacity 透明度
 @param shadowRadius 渐变读
 */
- (void)setShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(float)shadowRadius;
- (void)unifySetShadow;

@end
