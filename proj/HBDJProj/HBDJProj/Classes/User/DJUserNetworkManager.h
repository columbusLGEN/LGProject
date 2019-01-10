//
//  DJUserNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DJUpdateUserInfoKey) {
    DJUpdateUserInfoKeyPhone,
    DJUpdateUserInfoKeyName,
    DJUpdateUserInfoKeyImage,
    DJUpdateUserInfoKeyPassword
};

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

typedef NS_ENUM(NSUInteger, DJUserAddScoreType) {
    /** 分享微党课 */
    DJUserAddScoreTypeLessonShare = 3,
    /** 分享学习问答 */
    DJUserAddScoreTypeQAShare = 10,
    /** 查看、收听 微党课内容 */
    DJUserAddScoreTypeReadLesson = 2,
    /** 查看要闻 */
    DJUserAddScoreTypeReadNews = 6,
    /** 阅读图书 */
    DJUserAddScoreTypeReadBook = 7,
    /** 查看学习问答 */
    DJUserAddScoreTypeReadQA = 9,
    /** 查看支部动态 */
    DJUserAddScoreTypeReadBranch = 13,
    /** 查看党员舞台 */
    DJUserAddScoreTypeReadPYQ = 17,
    /** 查看三会一课 */
    DJUserAddScoreTypeReadThreeMeeting = 22,
    /** 查看主题党日 */
    DJUserAddScoreTypeReadThemeDay = 23,
    /** 查看思想汇报 */
    DJUserAddScoreTypeReadMindReport = 24,
    /** 查看述职述廉 */
    DJUserAddScoreTypeReadSpeech = 25,
};

@interface DJUserNetworkManager : NSObject

/** 查看未读消息数量 */
- (void)frontUserNotice_selectUnReadNumSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/**
 用户获取积分并提升等级接口
 @param integralid 积分类型id
 @param completenum 次数/分钟
 */
- (void)frontIntegralGrade_addWithIntegralid:(DJUserAddScoreType)integralid completenum:(double)completenum success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 获取支部动态详情 */
- (void)frontBranch_selectDetailWithSeqid:(NSInteger)seqid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 获取提问详情接口(消息中心查看消息详情) */
- (void)frontQuestionanswer_selectDetailWithSeqid:(NSInteger)seqid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 标记我的消息已读 */
- (void)frontUserNotice_updateWithId:(NSInteger)seqid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 批量删除我的消息 */
- (void)frontUserNotice_deleteWithSeqids:(NSString *)seqids success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 批量删除我的上传 */
- (void)frontUgc_deleteWithSeqids:(NSString *)seqids success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 批量删除收藏 */
- (void)frontUserCollections_deleteBatchWithCoids:(NSString *)coids success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 修改个人信息 */
- (void)frontUserinfo_updateWithInfoDict:(NSDictionary *)infoDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 查看今日获取积分 */
- (void)frontIntegralGrade_selectTaskSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 查看积分获取规则 */
- (void)frontIntegralGrade_selectIntegralSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 等级介绍 */
- (void)frontIntegralGrade_selectSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 提交反馈 */
- (void)frontFeedback_addWithTitle:(NSString *)title success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
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
 token登陆

 @param token token
 @param userId userid
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)userLoginWithToken:(NSString *)token userId:(NSString *)userId success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 激活账号
 
 @param tel 手机号
 @param oldPwd 旧密码（初始密码）
 @param pwd 新密码
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)userActivationWithTel:(NSString *)tel oldPwd:(NSString *)oldPwd pwd:(NSString *)pwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

NSString *dj_updateUserInfoKey(DJUpdateUserInfoKey infoKey);

CM_SINGLETON_INTERFACE
@end
