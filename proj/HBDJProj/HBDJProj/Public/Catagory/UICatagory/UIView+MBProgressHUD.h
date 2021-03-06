//
//  UIView+MBProgressHUD.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBProgressHUD;
#pragma mark - UIView

@interface UIView (MBProgressHUD)

- (MBProgressHUD *)presentMessageTips:(NSString *)message;
- (MBProgressHUD *)presentSuccessTips:(NSString *)message;
- (MBProgressHUD *)presentFailureTips:(NSString *)message;
- (MBProgressHUD *)presentLoadingTips:(NSString *)message;
- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide;

- (MBProgressHUD *)showWaitTips; // 转菊花等待

- (void)dismissTips;

@end

#pragma mark - UIViewController

@interface UIViewController (MBProgressHUD)

- (MBProgressHUD *)presentMessageTips:(NSString *)message;
- (MBProgressHUD *)presentSuccessTips:(NSString *)message;
- (MBProgressHUD *)presentFailureTips:(NSString *)message;
- (MBProgressHUD *)presentLoadingTips:(NSString *)message;
- (MBProgressHUD *)showTipsWithYOffset:(NSString *)message autoHide:(BOOL)autoHide;

- (MBProgressHUD *)showWaitTips; // 转菊花等待
- (void)dismissTips;

@end
