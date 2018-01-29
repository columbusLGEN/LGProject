//
//  UIImage+ColorImage.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(ColorImage)

/**
 创建颜色图片

 @param color 颜色
 @return 图片
 */
- (UIImage *)initWithColor:(UIColor *)color;

@end
