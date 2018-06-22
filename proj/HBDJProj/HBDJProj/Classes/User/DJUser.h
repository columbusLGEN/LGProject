//
//  DJUser.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/21.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 注意：该类属性的上下书写顺序千万不能改！！并且，不能在扩展中添加属性!!

#import <Foundation/Foundation.h>

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
/** 姓名 */
@property (strong,nonatomic) NSString *name;
/** 手机号 */
@property (strong,nonatomic) NSString *phone;
/** 民族,后台返回id，本地获取名称 */
@property (strong,nonatomic) NSString *nation;
/** 职务 */
@property (strong,nonatomic) NSString *post;
/** 入党时间 */
@property (strong,nonatomic) NSString *jiontime;
/** 转正时间 */
@property (strong,nonatomic) NSString *formaltime;
/** 工作单位 */
@property (strong,nonatomic) NSString *workunit;
/** 所在支部 */
@property (strong,nonatomic) NSString *mechanismname;
@property (strong,nonatomic) NSString *partyproperty;

/** 用户id */
@property (strong,nonatomic) NSString *seqid;
/** 性别:1男，0女 */
@property (strong,nonatomic) NSString *gender;
/** 年龄 */
@property (assign,nonatomic) NSInteger age;
/** 学位：1高职高专，2专科，3本科，4硕士，5博士及以上 */
@property (strong,nonatomic) NSString *degree;
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

@property (strong,nonatomic) NSString *birthday;

@property (strong,nonatomic) NSString *lastlogintime;

@property (strong,nonatomic) NSString *hometown;

@property (assign,nonatomic) BOOL ismanager;

@property (strong,nonatomic) NSString *developparty;
@property (strong,nonatomic) NSString *labelid;
@property (strong,nonatomic) NSString *bonuspenalty;
@property (strong,nonatomic) NSString *crowdtype;

/** 身份证 */
@property (strong,nonatomic) NSString *identitycard;

@property (strong,nonatomic) NSString *userid;

@property (strong,nonatomic) NSString *nationName;

@end
