//
//  UserInfoModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

/**
 用户信息
 */

/** 用户id */
@property (assign, nonatomic) NSInteger userId;

/** 用户类型 */
@property (assign, nonatomic) ENUM_UserType userType;

/** 昵称 */
@property (strong, nonatomic) NSString *name;

/** 头像 */
@property (strong, nonatomic) NSString *iconUrl;

/** 居住地 */
@property (strong, nonatomic) NSString *address;

/** 性别 */
@property (assign, nonatomic) ENUM_SexType sex;

/** 母语 */
@property (assign, nonatomic) NSInteger motherTongue;

/** 国家编码 */
@property (assign, nonatomic) NSInteger country;

/** 国家名 */
@property (strong, nonatomic) NSString *countryName;

/** 学习汉语年数 */
@property (assign, nonatomic) NSInteger learnYears;

/** 学校 */
@property (strong, nonatomic) NSString *school;

/** 爱好 */
@property (strong, nonatomic) NSString *interest;

/** 生日 */
@property (strong, nonatomic) NSString *birthday;

/** 年龄 */
@property (assign, nonatomic) NSInteger age;

/** 手机号 */
@property (strong, nonatomic) NSString *phone;

/** 国家码 */
@property (assign, nonatomic) NSInteger areacode;

/** email */
@property (strong, nonatomic) NSString *email;

/** 皮肤 */
@property (strong, nonatomic) NSString *skin;

/** 所属机构 */
@property (assign, nonatomic) NSInteger organizationId;

/** 积分 */
@property (assign, nonatomic) NSInteger score;

/** 赠送的虚拟币 */
@property (assign, nonatomic) CGFloat giveVirtualCurrency;

/** 虚拟币 */
@property (assign, nonatomic) CGFloat virtualCurrency;

/** 阅历id */
@property (assign, nonatomic) NSInteger readHistoryId;

/** 阅读字数 */
@property (assign, nonatomic) NSInteger sameDayWord;

/** 阅读总时间 */
@property (assign, nonatomic) NSInteger readTime;

/** 总阅读字数 */
@property (assign, nonatomic) NSInteger wordCount;

/** 平均每天阅读字数 */
@property (assign, nonatomic) NSInteger averageWordCount;

/** 战胜了书友百分比 */
@property (assign, nonatomic) NSInteger ranking;

/** 已读书籍 */
@property (assign, nonatomic) NSInteger readHave;

/** 阅读完多少书籍 */
@property (assign, nonatomic) NSInteger readThrough;

/** 用户信息是否可以被好友查看 */
@property (assign, nonatomic) BOOL canview;

/** 全平台包月 */
@property (assign, nonatomic) BOOL allbooks;

/** 学习汉语学生数 */
@property (strong, nonatomic) NSString *studentNum;

/** 学校类型 */
@property (assign, nonatomic) ENUM_SchoolType schoolType;

/** 备注 */
@property (strong, nonatomic) NSString *remark;

/* 班级id */
@property (assign, nonatomic) NSInteger classId;

/** 所属班级名 */
@property (strong, nonatomic) NSString *className;

/** 消息 */
@property (strong, nonatomic) NSArray *message;

/** 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。*/
@property (strong, nonatomic) NSString *unionid;

/** 选中 */
@property (assign, nonatomic) BOOL isSelected;

/** 获取消息的时间 */
@property (strong, nonatomic) NSString *messageTime;

/** 全平台租阅截止时间 */
@property (strong, nonatomic) NSString *endtime;

// 深拷贝
- (id)copyWithZone:(NSZone *)zone;

@end
