//
//  UIImage+ColorImage.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UIImage+ColorImage.h"

@implementation UIImage(ColorImage)

//通过颜色来生成一个纯色图片
- (UIImage *)initWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, Screen_Width, Screen_Height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
