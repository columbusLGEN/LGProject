//
//  UIImage+Extension.h
//  LGProject
//
//  Created by Peanut Lee on 2018/1/5.
//  Copyright © 2018年 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)rectImageWithSize:(CGSize)size color:(UIColor *)color;
/** 改变UIImage 颜色 */
- (UIImage *)changeImgColor:(UIColor *)color;
/** 根据颜色生成 UIImage */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
