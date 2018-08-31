//
//  DJUserNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DJMCType) {
    /** 所有 */
    DJMCTypeAll,
    /** 微党课 */
    DJMCTypeLesson,
    /** 新闻 */
    DJMCTypeNews,
    /** 学习问答 */
    DJMCTypeQA,
    /** 支部动态 */
    DJMCTypeBrance,
    /** 党员舞台 */
    DJMCTypePYQ
};

@interface DJUserNetworkManager : NSObject

/** 查询我的反馈 */
- (void)frontFeedback_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 请求 帮助与反馈数据 */
- (void)frontFeedback_selectIndexWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 我的上传 ugctype: 1党员舞台,2思想汇报,3述职述廉 */
- (void)frontUgc_selectWithUgctype:(DJOnlineUGCType)ugctype offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 我的收藏
 type: 0所有 1微党课 2新闻 3学习问答 4支部动态 5党员舞台 */
- (void)frontUserCollections_selectWithType:(DJMCType)type offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 我的消息 */
- (void)frontUserNotice_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 我的提问 */
- (void)frontQuestionanswer_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 请求个人信息 */
- (void)frontUserinfo_selectSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

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
