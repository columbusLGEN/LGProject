//
//  DJUserNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJUserNetworkManager : NSObject

/** 登出当前用户 */
- (void)userLogoutSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 登录
 
 @param tel 手机
 @param pwd_md5 密码MD5值
 @param success 成功
 @param failure 失败
 */
- (void)userLoginWithTel:(NSString *)tel pwd_md5:(NSString *)pwd_md5 success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 激活账号
 
 @param tel 手机号
 @param oldPwd 旧密码（初始密码）
 @param pwd 新密码
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)userActivationWithTel:(NSString *)tel oldPwd:(NSString *)oldPwd pwd:(NSString *)pwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

CM_SINGLETON_INTERFACE
@end
