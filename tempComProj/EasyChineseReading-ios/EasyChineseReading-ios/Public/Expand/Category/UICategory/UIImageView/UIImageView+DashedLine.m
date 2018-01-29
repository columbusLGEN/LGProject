//
//  UIImageView+DashedLine.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UIImageView+DashedLine.h"

@implementation UIImageView(DashedLine)

// 返回虚线image的方法
+ (UIImage *)drawLineByImageView:(UIImageView *)imageView rect:(CGRect)rect point:(CGPoint)point  {
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {1,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithWhite:0.408 alpha:1.000].CGColor);
    CGContextSetLineDash(line, 0, lengths, 1); //画虚线
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标
    CGContextMoveToPoint(line, 0.0, 0.0); //开始画线
    //设置下一个坐标点
    CGContextAddLineToPoint(line, Screen_Width - 30, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
