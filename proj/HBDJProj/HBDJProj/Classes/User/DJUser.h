//
//  DJUser.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/21.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 注意：该类属性的上下书写顺序千万不能改！！并且，不能在扩展中添加属性!!

#import <Foundation/Foundation.h>

static NSString * const NWiFi_notice_key = @"NWiFi_notice_key";

@interface DJUser : NSObject

/** 将实例的属性值保存到本地偏好中 */
- (void)keepUserInfo;
/** 将本地偏好中的值取出来，赋值给实例的属性 */
- (void)getLocalUserInfo;
/** 删除本地用户信息 */
- (void)removeLocalUserInfo;
/** 返回 属性名 数组 */
- (NSArray *)propertyArray;
+ (instancetype)sharedInstance;

/** 头像链接 */
@property (strong,nonatomic) NSString *image;
/** 姓名，用户名 */
@property (strong,nonatomic) NSString *name;
/** 手机号 */
@property (strong,nonatomic) NSString *phone;
/** 性别:1男，0女 */
@property (strong,nonatomic) NSString *gender;
/** 籍贯 */
@property (strong,nonatomic) NSString *hometown;
/** 民族,后台返回id，本地获取名称 */
@property (strong,nonatomic) NSString *nation;
/** 出生日期 */
@property (strong,nonatomic) NSString *birthday;
/** 学位：1高职高专，2专科，3本科，4硕士，5博士及以上 */
@property (strong,nonatomic) NSString *degree;
/** 入党时间 */
@property (strong,nonatomic) NSString *jiontime;
/** 转正时间 */
@property (strong,nonatomic) NSString *formaltime;
/** 党内职务 */
@property (strong,nonatomic) NSString *post;
/** 党员属性 */
@property (strong,nonatomic) NSString *partyproperty;
/** 发展党员 */
@property (strong,nonatomic) NSString *developparty;
/** 人群类型 */
@property (strong,nonatomic) NSString *crowdtype;
/** 工作单位 */
@property (strong,nonatomic) NSString *workunit;
/** 奖惩情况 */
@property (strong,nonatomic) NSString *bonuspenalty;

/// ------------------分割线---以上内容在个人信息页面展示---------------


/** 等级名称 */
@property (strong,nonatomic) NSString *gradename;
/** 所在支部 */
@property (strong,nonatomic) NSString *mechanismname;

/** 用户id */
@property (strong,nonatomic) NSString *seqid;

/** 年龄 */
@property (assign,nonatomic) NSInteger age;

/** 密码 */
@property (strong,nonatomic) NSString *password;
/** 原属机构 */
@property (strong,nonatomic) NSString *mechanismid;
/** 积分 */
@property (assign,nonatomic) CGFloat integral;

@property (strong,nonatomic) NSString *token;

@property (strong,nonatomic) NSString *createdtime;
@property (assign,nonatomic) NSInteger creatorid;
@property (assign,nonatomic) NSInteger status;



@property (strong,nonatomic) NSString *lastlogintime;

@property (assign,nonatomic) BOOL ismanager;

@property (strong,nonatomic) NSString *labelid;

/** 身份证 */
@property (strong,nonatomic) NSString *identitycard;

@property (strong,nonatomic) NSString *userid;

@property (strong,nonatomic) NSString *nationName;

/** 非WIFI环境下播放视频提醒,如果用户没有设置,则提醒,0:用户未设置,1:提醒,2,不提醒 */
@property (assign,nonatomic) NSInteger WIFI_playVideo_notice;

@end
