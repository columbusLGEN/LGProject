//
//  NSObject+Category.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Category)

/** float函数转number */
- (NSNumber *)floatToNumber:(CGFloat)floatNumber;
/** 获取与设置设备唯一标识符 */
- (void)deviceUUID;
/** 获取当前最上面的控制器 */
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;

@end
