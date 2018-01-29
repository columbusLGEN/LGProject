//
//  WXLogin.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/30.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(id object,NSError * error);

@interface WXLogin : NSObject

CM_SINGLETON_INTERFACE(WXLogin)

/** 获取 code */
- (void)getCode;
/** 通过 code 获取 accessToken 等信息 */
- (void)getAccessTokenWithCode:(NSString *)code complete:(completeBlock)complete;
/** 通过 accessToken 获取 userinfo */
- (void)getUserInfoComplete:(completeBlock)complete;
/** 通过 refreshToken 刷新 accessToken */
- (void)refreshAccessTokenComplete:(completeBlock)complete;
/** 检查 accessToken 是否过期 */
- (void)checkAccessTokenComplete:(completeBlock)complete;

@end
