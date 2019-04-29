//
//  LGParallelButton.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/25.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGParallelButton.h"

@interface LGParallelButton ()

@end

@implementation LGParallelButton

- (void)config{
    [self setTitleColor:UIColor.TCColor_mainColor forState:UIControlStateNormal];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self config];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect {
//    /// 添加文字下划线
//    CGRect textRect = self.titleLabel.frame;
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//
//    UIColor *lineColor = UIColor.TCColor_mainColor;
//
//    CGFloat descender = self.titleLabel.font.descender;
//    if([lineColor isKindOfClass:[UIColor class]]){
//        CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
//    }
//
//    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+1);
//    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender+1);
//
//    CGContextClosePath(contextRef);
//    CGContextDrawPath(contextRef, kCGPathStroke);
//
//}
@end
