//
//  UIViewController+Camera.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController(Camera)<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (void)showAlertForSystemPhotoWithTitle:(NSString *)title;

/**
 * 取到数据之后,待处理
 */
- (void)handleImgWith:(UIImage *)image;

@end
