//
//  LGTriangleView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGTriangleView.h"

@implementation LGTriangleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [[UIColor whiteColor] set];
    UIRectFill(rect);
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, width / 2, 0);
    CGContextAddLineToPoint(context, 0, height);
    CGContextAddLineToPoint(context, width, height);
    
    CGContextClosePath(context);
    
    UIColor *fillColor = [UIColor EDJGrayscale_F5];
    [fillColor setFill];
    [fillColor setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
