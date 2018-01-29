//
//  UIView+Category.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2018/1/22.
//  Copyright © 2018年 retech. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView(Category)

- (void)drawRoundedRectPathWithView:(UIView *)view
{
// 切圆角
// 切掉背景的右上角, 左下角
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_viewBackground.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _viewBackground.bounds;
//    maskLayer.path = path.CGPath;
//    _viewBackground.layer.mask = maskLayer;
    
    // 创建带圆角的矩形  圆角半径：10
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(view.x, view.y, view.width, view.height) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    
    // 创建可以指定圆角位置的矩形
    // 第一个参数一样是传了个矩形
    // 第二个参数是指定在哪个方向画圆角
    // 第三个参数是一个CGSize类型，用来指定水平和垂直方向的半径的大小
    
    //配置属性
    [[UIColor whiteColor] setFill];              // 设置填充颜色
    [[UIColor cm_lineColor_D9D7D7_1] setStroke]; // 设置描边颜色
    path.lineWidth = .5f;                        // 设置线宽
    [path closePath];                            // 封闭图形
    
    //渲染
    [path stroke];
    [path fill];
}

@end
