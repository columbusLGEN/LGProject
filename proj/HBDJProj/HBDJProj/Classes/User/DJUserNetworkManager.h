//
//  DJUserNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJUserNetworkManager : NSObject


/**
 修改密码

 @param oldPwd 旧密码
 @param newPwd 新面貌
 */
- (void)userUpdatePwdWithOld:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/**
 忘记密码 & 修改密码接口

 @param phone 电话号码
 @param newPwd 新密码
 @param oldPwd 旧密码
 */
- (void)userForgetChangePwdWithPhone:(NSString *)phone newPwd:(NSString *)newPwd oldPwd:(NSString *)oldPwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;


/**
 验证验证码接口

 @param phone 手机号
 @param code 验证码
 */
- (void)userVerrifiCodeWithPhone:(NSString *)phone code:(NSString *)code success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 发送验证码接口

 @param phone 手机号
 */
- (void)userSendMsgWithPhone:(NSString *)phone success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

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
