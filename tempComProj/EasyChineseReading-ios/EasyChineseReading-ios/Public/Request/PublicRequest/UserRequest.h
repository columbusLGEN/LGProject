//
//  UserInfo.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

#import "CacheDataSource.h"

@interface UserRequest : BaseNetRequest

#pragma mark ========== 用户信息相关网络请求 ==========

#pragma mark - 用户信息记录及判断

@property (strong, nonatomic) UserModel * user;
@property (strong, nonatomic) NSString  * token;
@property (strong, nonatomic) NSString  * deviceToken;

CM_SINGLETON_INTERFACE(UserRequest)

///**
// * 记录登录过的用户信息，电话号，昵称
// */
//@property (strong, nonatomic) NSString *userphone;//电话号
//@property (strong, nonatomic) NSString *userNickName;//昵称

- (ENUM_LanguageType)language;

/** 保存信息 */
- (void)saveCache;
/** 获取信息 */
- (void)loadCache;
/** 清除信息 */
- (void)clearCache;

/** 在线判断 */
+ (BOOL)online;
- (BOOL)online;

/** 退出登录 */
- (void)signout;
/** 在其他机器登录，被踢下线 */
//- (void)kickout;
- (void)kickoutWithMessage:(NSString *)errorMessage;

#pragma mark ========== 数据接口 ==========

#pragma mark - 获取用户信息

/**
 获取登录用户信息
 
 @param completion  回调
 */
- (void)getUserInfoWithCompletion:(CompleteBlock)completion;

#pragma mark - 用户注册

/**
 用户注册
 
 @param type       用户类型 （1 手机 2 邮箱）
 @param userType   账号类型 （1 普通 3 机构）
 @param password   密码
 @param school     学校
 @param schoolType 学校类型
 @param learnChNum 学习汉语学生数量
 @param country    国家
 @param name       姓名
 @param email      邮箱
 @param phone      手机号
 @param areacode   国家码
 @param countryName 国家名
 @param completion 回调
 */
- (void)registerUserWithType:(NSString *)type
                    userType:(NSString *)userType
                    password:(NSString *)password
                      school:(NSString *)school
                  schoolType:(NSString *)schoolType
                  learnChNum:(NSString *)learnChNum
                     country:(NSString *)country
                        name:(NSString *)name
                       email:(NSString *)email
                       phone:(NSString *)phone
                    areacode:(NSString *)areacode
                 countryName:(NSString *)countryName
                  completion:(CompleteBlock)completion;


/**
 微信注册
 
 @param dic        微信返回的用户信息字典
 @param type       账号类型
 @param phone      手机
 @param email      邮箱
 @param areacode   国家码
 @param completion 回调
 */
- (void)registerWithWeChatInfo:(NSDictionary *)dic
                         phone:(NSString *)phone
                         email:(NSString *)email
                      areacode:(NSString *)areacode
                          type:(ENUM_AccountType)type
                    completion:(CompleteBlock)completion;


#pragma mark - 验证账户的唯一性

/**
 验证账户的唯一性
 
 @param userName   账号（手机 邮箱）
 @param userType   账号类型 （手机 邮箱）
 @param completion 回调
 */
- (void)verifyAccountSingleWithUserName:(NSString *)userName
                               userType:(NSString *)userType
                             completion:(CompleteBlock)completion;

#pragma mark - 用户登录
/**
 token 登录
 
 @param token      token
 @param completion 回调
 */
- (void)loginWithToken:(NSString *)token
            completion:(CompleteBlock)completion;

/**
 用户登录
 
 @param type       登录类型（1.token登录--没有退出账号，关闭app后再次打开需要验证token，使用此接口token登录 2.密码登录）
 @param userType   账号类型（1.手机号 2.邮箱）
 @param user       账号
 @param password   密码
 @param userId     用户id(与token配对使用)
 @param token      token
 @param accountType 登录类型(0 普通用户 1 机构)
 @param completion 回调
 */
- (void)loginWithType:(NSString *)type
             userType:(NSString *)userType
                 user:(NSString *)user
             password:(NSString *)password
               userId:(NSString *)userId
                token:(NSString *)token
          accountType:(NSString *)accountType
           completion:(CompleteBlock)completion;

/**
 微信登录
 
 @param unionid     微信返回的 unionid
 @param completion  回调
 */
- (void)loginWithWeChatUnionid :(NSString *)unionid
                     completion:(CompleteBlock)completion;

/**
 退出登录

 @param completion 回调
 */
- (void)logoutWithCompletion:(CompleteBlock)completion;

#pragma mark - 记录登录时长

/**
 记录登录时长

 @param country    地址
 @param completion 回调
 */
- (void)logOnlineTimeWithCountry:(NSString *)country
                      completion:(CompleteBlock)completion;

#pragma mark - 发送手机验证码

/**
 发送手机验证码
 
 @param phone      手机号
 @param areacode   国家码
 @param completion 回调
 */
- (void)sendPhoneCodeWithPhone:(NSString *)phone
                      areacode:(NSString *)areacode
                    completion:(CompleteBlock)completion;


#pragma mark - 发送邮箱验证码

/**
 发送邮箱验证码
 
 @param email      邮箱
 @param completion 回调
 */
- (void)sendEmailCodeWithEmail:(NSString *)email
                    completion:(CompleteBlock)completion;

#pragma mark - 验证验证码

/**
 验证验证码
 
 @param type        验证码类型
 @param verifi      验证码
 @param account     账号
 @param completion  回调
 */
- (void)verityCodeWithType:(NSString *)type
                    verifi:(NSString *)verifi
                   account:(NSString *)account
                completion:(CompleteBlock)completion;

#pragma mark - 修改用户信息

/**
 修改用户信息
 
 @param name        名字
 @param address     地址
 @param sex         性别
 @param language    母语
 @param country     国籍
 @param learnYears  学习汉语年数
 @param interest    兴趣爱好
 @param birthday    生日
 @param iconUrl     头像
 @param school      学校
 @param countryName 国家名
 @param completion  回调
 */
- (void)updateUserInfoWithName:(NSString *)name
                       address:(NSString *)address
                           sex:(NSString *)sex
                      language:(NSString *)language
                       country:(NSString *)country
                     learnyear:(NSString *)learnYears
                      interest:(NSString *)interest
                      birthday:(NSString *)birthday
                       iconUrl:(NSString *)iconUrl
                        school:(NSString *)school
                   countryName:(NSString *)countryName
                    completion:(CompleteBlock)completion;

#pragma mark - 修改邮箱或手机接口

/**
 修改邮箱或手机号
 
 @param type       修改的类型 1 手机 2邮箱
 @param account    账号(邮箱或手机)
 @param areacode   国家码
 @param completion 回调
 */
- (void)updateUserInfoWithType:(NSString *)type
                       account:(NSString *)account
                      areacode:(NSString *)areacode
                    completion:(CompleteBlock)completion;

#pragma mark - 修改密码

/**
 修改密码
 
 @param type        修改密码的类型（1 登录 2 支付）
 @param userId      用户 id
 @param password    新密码
 @param completion  回调
 */
- (void)updatePasswordWithType:(NSString *)type
                        userId:(NSInteger )userId
                      password:(NSString *)password
                    completion:(CompleteBlock)completion;

#pragma mark - 找回密码

/**
 找回密码
 
 @param account     账号
 @param accountType 账号类型
 @param areacode    国家码
 @param password    密码
 @param completion  回调
 */
- (void)forgetPasswordWithAccount:(NSString *)account
                      accountType:(ENUM_AccountType)accountType
                         areacode:(NSString *)areacode
                         password:(NSString *)password
                       completion:(CompleteBlock)completion;

#pragma mark - 上传图片

/**
 上传图片
 
 @param imgInfo     图片
 @param completion  回调
 */
- (void)postImageWithImageInfo:(NSString *)imgInfo
                    completion:(CompleteBlock)completion;

#pragma mark - 用户阅历分享

/**
 用户阅历分享
 
 @param completion 回调
 */
- (void)shareReadHistoryWithCompletion:(CompleteBlock)completion;

#pragma mark - 卡券

/**
 卡密兑换
 
 @param exchange 卡密
 @param completion 回调
 */
- (void)exchangeWithExchangeId:(NSString *)exchange
                    completion:(CompleteBlock)completion;

/**
 领券中心中获取所有的卡券
 
 @param completion 回调
 */
- (void)getAllTicketesWithCompletion:(CompleteBlock)completion;

/**
 获取我的卡券
 
 @param completion 回调
 */
- (void)getMyTicketsWithCompletion:(CompleteBlock)completion;

/**
 领券中心领取卡券
 
 @param ticketId    卡券 id
 @param completion  回调
 */
- (void)getTicketWithTicketId:(NSInteger)ticketId
                   completion:(CompleteBlock)completion;

/**
 通过 cdkey 获取卡券
 
 @param code       cdkey
 @param completion 回调
 */
- (void)getTicketWithCode:(NSString *)code
                     type:(ENUM_TicketType)type
               completion:(CompleteBlock)completion;

/**
 获取卡券对应的图书
 
 @param ticketType 满减类型
 @param page       页数
 @param length     每页数量
 @param sort       排序方式
 @param completion 回调
 */
- (void)getTicketCorrespondBooksWithTicketType:(NSString *)ticketType
                                          page:(NSInteger)page
                                        length:(NSInteger)length
                                          sort:(NSInteger)sort
                                    completion:(CompleteBlock)completion;

#pragma mark - 设置阅读历史可见

/**
 设置阅读历史可见
 
 @param canBrowe   是否可以查看 1可见 0不可见
 @param completion 回调
 */
- (void)updateUserInfoCanBrowse:(NSString *)canBrowe
                     completion:(CompleteBlock)completion;

#pragma mark - 获取虚拟币消费记录列表

/**
 获取虚拟币消费记录列表
 
 @param page       第几页
 @param completion 回调
 */
- (void)getVirtualCurrencyListWithPage:(NSString *)page
                            completion:(CompleteBlock)completion;

#pragma mark - 获取积分获取及消费列表

/**
 获取积分获取及消费列表
 
 @param page       第几页
 @param completion 回调
 */
- (void)getIntegralListWithPage:(NSString *)page
                     completion:(CompleteBlock)completion;

#pragma mark - 获取国家

/**
 获取国家列表
 
 @param completion 回调
 */
- (void)getCountrysComplention:(CompleteBlock)completion;

#pragma mark - 意见反馈

/**
 意见反馈

 @param message       反馈内容
 @param phoneModel    手机型号
 @param mobileSystem  操作系统
 @param appversion    软件版本
 @param completion    回调
 */
- (void)submitFeedbackWithMessage:(NSString *)message
                       phoneModel:(NSString *)phoneModel
                     mobileSystem:(NSString *)mobileSystem
                       appversion:(NSString *)appversion
                       completion:(CompleteBlock)completion;


@end
