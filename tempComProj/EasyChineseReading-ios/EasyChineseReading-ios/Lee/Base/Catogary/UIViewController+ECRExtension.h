//
//  UIViewController+ECRExtension.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ECRExtension)

/**
 判断用户是否在线

 @param onLine 在线
 @param offLine 离线
 */
- (void)userOnLine:(void(^)())onLine offLine:(void(^)())offLine;

@end
