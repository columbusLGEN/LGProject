//
//  UIImage+LEEImageExtension.h
//  TOP6000
//
//  Created by user on 17/2/22.
//  Copyright © 2017年 Len. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LEEImageExtension)
// 改变 UIImgae 的颜色
- (UIImage *)changeImgColor:(UIColor *)color;

// 根据颜色 生成 image 对象
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
