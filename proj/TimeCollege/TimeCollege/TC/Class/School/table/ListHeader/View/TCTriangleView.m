//
//  TCTriangleView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCTriangleView.h"

@implementation TCTriangleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    /// 绘制三角形,角朝下
    /// 1.获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /// 2.创建路径
    CGMutablePathRef path = CGPathCreateMutable();

    /// 2.2起点
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    /// 2.3顶点
    CGPathAddLineToPoint(path, NULL, rect.size.width, 0);
    
    /// 2.4终点
    CGPathAddLineToPoint(path, NULL, rect.size.width / 2, rect.size.height);

    /// 3.把路径添加到上下文
    CGContextAddPath(context, path);
    
    /// 4.其他设置
    
    // 设置线宽
//    CGContextSetLineWidth(cxt, 10.0f);
//    // 设置颜色
//    [[UIColor TCColor_mainColor] set];
//    CGContextSetRGBStrokeColor(context, 1, 0.6, 0.9, 1);
    
//    // 线的样式
//    CGContextSetLineCap(cxt, kCGLineCapRound);
//    // 填充 闭合形状里面的颜色  就是上图里面的红色填充
    [[UIColor YBColor_E8F3FE] setFill];
//    // 描边 线边的颜色
    [[UIColor YBColor_E8F3FE] setStroke];

    /// 渲染
//#参数1: 上下文
//#参数2:  渲染的方式(枚举值可以点进去看)  这个是 既要描边 又要填充
    CGContextDrawPath(context, kCGPathFillStroke);
    

}


@end
