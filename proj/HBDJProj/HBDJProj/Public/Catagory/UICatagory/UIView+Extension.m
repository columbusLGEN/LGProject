//
//  UIView+Extension.m
//  LGProject
//
//  Created by Peanut Lee on 2017/12/28.
//  Copyright © 2017年 LG. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

/// MARK: 切圆形
- (void)cutToCycle{
    self.layer.cornerRadius = self.width * 0.5;
    self.layer.masksToBounds = YES;
}

/// MARK: 设置阴影
- (void)setShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(float)shadowRadius{
    // 颜色
    self.layer.shadowColor = shadowColor.CGColor;
    // offset
    self.layer.shadowOffset = shadowOffset;
    // 透明度
    self.layer.shadowOpacity = shadowOpacity;
    // 阴影渐变
    self.layer.shadowRadius = shadowRadius;
    self.layer.masksToBounds = NO;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)size{
    CGRect freme = self.frame;
    freme.size = size;
    self.frame = freme;
}
- (CGSize)size{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY{
    return self.center.y;
}

/// 随机背景色
- (void)randomBackgroundColor{
    int r = arc4random_uniform(255);
    int g = arc4random_uniform(255);
    int b = arc4random_uniform(255);
    self.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}


@end
