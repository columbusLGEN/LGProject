//
//  LGPImageOperator.m
//  RGTestPorject
//
//  Created by Peanut Lee on 2017/12/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "LGPImageOperator.h"

@implementation LGPImageOperator

/** 等比例缩放图片 */
+ (UIImage *)cropImage:(UIImage *)image scale:(CGFloat)scale{
    CGSize newSize = CGSizeMake(image.size.width*scale, image.size.height*scale);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 给图片添加水印 */
+ (UIImage *)addWatermarkWith:(UIImage *)image watemarkImage:(UIImage *)watermarkImage size:(CGSize)size wmiRect:(CGRect)wmiRect{
    return [[self sharedInstance] addWatermarkWith:image watemarkImage:watermarkImage size:size wmiRect:wmiRect];
}
- (UIImage *)addWatermarkWith:(UIImage *)image watemarkImage:(UIImage *)watermarkImage size:(CGSize)size wmiRect:(CGRect)wmiRect{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [watermarkImage drawInRect:CGRectMake(wmiRect.origin.x, wmiRect.origin.y, wmiRect.size.width, wmiRect.size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)addWatermarkTextWith:(UIImage *)image text:(NSString *)text{
    return [[self sharedInstance] addWatermarkTextWith:image text:text];;
}
- (UIImage *)addWatermarkTextWith:(UIImage *)image text:(NSString *)text{
    int w = image.size.width;
    int h = image.size.height;
    UIGraphicsBeginImageContext(image.size);
    [[UIColor whiteColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:50];
    // 测试数据
    [text drawInRect:CGRectMake(10, 10, 100, 80) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * 加半透明水印@param logoImage 需要加水印的图片@param translucentWatemarkImage 水印@returns 加好水印的图片
 */
+ (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage translucentWatemarkImage:(UIImage *)translucentWatemarkImage logoImageRect:(CGRect)logoImageRect translucentWatemarkImageRect:(CGRect)translucentWatemarkImageRect{
    return [[self sharedInstance] addWatemarkImageWithLogoImage:logoImage translucentWatemarkImage:translucentWatemarkImage logoImageRect:logoImageRect translucentWatemarkImageRect:translucentWatemarkImageRect];
}
- (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage translucentWatemarkImage:(UIImage *)translucentWatemarkImage logoImageRect:(CGRect)logoImageRect translucentWatemarkImageRect:(CGRect)translucentWatemarkImageRect{
    UIGraphicsBeginImageContext(logoImage.size);    [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
    // 四个参数为水印的位置
    [translucentWatemarkImage drawInRect:CGRectMake(logoImage.size.width - 110, logoImage.size.height - 25, 100, 25)];
    UIImage * resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}



@end
