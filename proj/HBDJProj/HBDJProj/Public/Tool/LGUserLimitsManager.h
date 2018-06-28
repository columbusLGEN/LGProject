//
//  LGUserLimitsManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGUserLimitsManager : NSObject

/// MARK: 检查麦克风权限
- (void)microPhoneLimitCheck:(void(^)(void))permitted denied:(void(^)(void))denied;
/// MARK: 请求麦克风权限弹窗
- (UIAlertController *)showSetMicroPhoneAlertView;

@end
