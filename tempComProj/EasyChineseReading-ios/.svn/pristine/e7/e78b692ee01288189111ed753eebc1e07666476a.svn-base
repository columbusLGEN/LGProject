//
//  UIView+Extension.m
//  HaoWeibo
//
//  Created by 张仁昊 on 16/3/9.
//  Copyright © 2016年 张仁昊. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

/**
 设置阴影
 
 @param shadowColor 阴影颜色
 @param shadowOffset 偏移量
 @param shadowOpacity 透明度
 @param shadowRadius 渐变读
 */
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
/// 该方法仅用于首页统一设置
- (void)unifySetShadow{
    // 颜色
    self.layer.shadowColor = [LGSkinSwitchManager homeSkinShadowColor].CGColor;
    // offset
    self.layer.shadowOffset = CGSizeMake(0, 3);
    // 透明度
    self.layer.shadowOpacity = 1;
    // 阴影渐变
    self.layer.shadowRadius = 0;
    self.layer.masksToBounds = NO;
}

// test 测试用
- (void)randomBackgroundColor{
    int r = arc4random_uniform(255);
    int g = arc4random_uniform(255);
    int b = arc4random_uniform(255);
    self.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

-(void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)x{
    
    return self.frame.origin.x;
}

-(CGFloat)y{
    
    return self.frame.origin.y;
}

-(void)setCenterX:(CGFloat)centerX{
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerX{
    
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY{
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)centerY{
    
    return self.center.y;
}

-(void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height{
    
    return self.frame.size.height;
}

-(CGFloat)width{
    
    return self.frame.size.width;
}

-(void)setSize:(CGSize)size{
    
    CGRect freme = self.frame;
    freme.size = size;
    self.frame = freme;
}

-(CGSize)size{
    
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin{
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGPoint)origin{
    
    return self.frame.origin;
}

// 判断View是否显示在屏幕上

- (BOOL)isDisplayedInScreen{
    
    if (self == nil) {
        
        return FALSE;
        
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    
    CGRect rect = [self convertRect:self.frame fromView:nil];
    
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        
        return FALSE;
        
    }
    
    // 若view 隐藏
    
    if (self.hidden) {
        
        return FALSE;
        
    }
    
    // 若没有superview
    
    if (self.superview == nil) {
        
        return FALSE;
        
    }
    
    // 若size为CGrectZero
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        
        return FALSE;
        
    }
    
    // 获取 该view与window 交叉的 Rect
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        
        return FALSE;
        
    }
    
    return TRUE;
    
}


- (void)resignAllFirstResponder
{
    NSAssert(NO, @"必须重写");
}


@end
