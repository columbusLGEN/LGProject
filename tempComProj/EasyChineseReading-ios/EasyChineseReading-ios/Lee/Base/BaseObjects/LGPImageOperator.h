//
//  LGPImageOperator.h
//  RGTestPorject
//
//  Created by Peanut Lee on 2017/12/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGPImageOperator : NSObject


/**
 等比例缩放图片

 @param image 原图
 @param scale 比例
 @return 新图
 */
+ (UIImage *)cropImage:(UIImage *)image scale:(CGFloat)scale;

/**
 给图片添加 水印(图片)
 
 @param image 原图
 @param watermarkImage 水印
 @param size 原图尺寸
 @param wmiRect 水印坐标 (watermarkImageRect)
 @return 目标图片
 */
+ (UIImage *)addWatermarkWith:(UIImage *)image watemarkImage:(UIImage *)watermarkImage size:(CGSize)size wmiRect:(CGRect)wmiRect;

/**
 * 给图片添加文字水印
 @param image 需要加文字的图片
 @param text 水印文字
 @return 加好文字水印的图片
 */
+ (UIImage *)addWatermarkTextWith:(UIImage *)image text:(NSString *)text;

+ (instancetype)sharedInstance;

@end
