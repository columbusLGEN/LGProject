//
//  UserInfo.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserRequest.h"
#import "AppDelegate.h"

@implementation UserRequest

CM_SINGLETON_IMPLEMENTION(UserRequest)

- (id)init
{
    if ( self = [super init] )
    {
        [self loadCache];
    }
    return self;
}

- (void)saveCache
{
    [[CacheDataSource sharedInstance] setCache:self.user withCacheKey:CacheKey_UserInfo];
    [[CacheDataSource sharedInstance] setCache:self.token withCacheKey:CacheKey_UserToken];
}

- (void)loadCache
{
    self.user  = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_UserInfo];
    self.token = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_UserToken];
}

- (void)clearCache	
{
//    [[CacheDataSource sharedInstance] clearAllUserDefaultsData];
    [[CacheDataSource sharedInstance] setCache:nil withCacheKey:CacheKey_UserInfo];
    [[CacheDataSource sharedInstance] setCache:nil withCacheKey:CacheKey_UserToken];
    
    self.token = @"";
    self.user = nil;
}

#pragma mark -

+ (BOOL)online
{
    return [[UserRequest sharedInstance] online];
}

- (BOOL)online
{
    if ([self.token notEmpty] && [UserRequest sharedInstance].user.userId > 0)
    {
        return YES;
    }
    return NO;
}

/** 退出登录 */
- (void)signout
{
//    if ( self.online )
//    {
        [self clearCache];
        [self fk_postNotification:kNotificationUserLogout];
//    }
}

/** 在其他机器登录，被踢下线 */
- (void)kickoutWithMessage:(NSString *)errorMessage
{
    if (self.online)
    {
        [self signout];
        // 显示被踢提示
        static ZAlertView *alertView;
        if (alertView == nil) {
//            NSString * str = LOCALIZATION(@"当前帐号在其他设备上登录。若非本人的操作，你的密码可能已经泄漏，请及时更改你的密码。");
            alertView = [[ZAlertView alloc] initWithTitle:errorMessage message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"确定") otherButtonTitles:nil,nil];
            alertView.whenDidSelectCancelButton = ^{
//                UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UIViewController *rVC = appDelegate.window.rootViewController;
                UIViewController *VC = [self getCurrentVCFrom:rVC];
                [VC.navigationController popToRootViewControllerAnimated:YES];
                alertView = nil;
            };
            [alertView show];
        }
    }
}

- (ENUM_LanguageType)language
{
    NSString *strLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    return [strLanguage isEqualToString:@"en"] ? ENUM_LanguageTypeEnglish : ENUM_LanguageTypeChinese;
}

#pragma mark -
#pragma mark ===== 数据 接口 =====
#pragma mark - 获取用户信息
/**
 获取登录用户信息

 @param completion  回调
 */
- (void)getUserInfoWithCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", self.user.userId]},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/personalInformation"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:responseObject];
                                     UserModel *user = [UserModel mj_objectWithKeyValues:array.firstObject];
                                     [UserRequest sharedInstance].user = user;
                                     [[CacheDataSource sharedInstance] setCache:self.user withCacheKey:@"user"];
                                     completion(user, nil);
                                 }
                             }];
}

/**
 记录登录时长
 
 @param country    地址
 @param completion 回调
 */
- (void)logOnlineTimeWithCountry:(NSString *)country
                      completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"loginadd": country.length > 0 ? country : @"中国",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/addTimeOfLogin"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

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
                  completion:(CompleteBlock)completion
{
    NSString *birthday = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_SelectBirthday];
    NSDictionary * dic = @{@"params": @{@"type"    : type,
                                        @"userType": userType.length > 0 ? userType : @"",
                                        @"password": password.length > 0 ? password : @"",
                                        @"school"  : school.length   > 0 ? school  : @"",
                                        @"schoolType": schoolType,
                                        @"learnChNum": learnChNum.length > 0 ? learnChNum : @"0",
                                        @"name"    : name.length  > 0 ? name  : @"",
                                        @"email"   : email.length > 0 ? email : @"",
                                        @"phone"   : phone.length > 0 ? phone : @"",
                                        @"country" : country,
                                        @"countryName" : countryName.length > 0 ? countryName : @"",
                                        @"birthday": birthday.length > 0 ? birthday : @"2000-01-01",
                                        @"areacode": areacode},
                           @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/register"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

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
                    completion:(CompleteBlock)completion
{
    NSInteger sex = [dic[@"sex"] integerValue];
    NSString *strSex = [NSString stringWithFormat:@"%ld", sex];
    CountryModel *country = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_SelectCountry];
    NSString *birthday = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_SelectBirthday];
    NSDictionary *dictionary = @{@"params": @{@"type"      : [NSString stringWithFormat:@"%ld", type],
                                              @"password"  : @"",
                                              @"email"     : email,
                                              @"phone"     : phone,
                                              @"areacode"  : areacode,
                                              @"headimgurl": dic[@"headimgurl"],
                                              @"nickname"  : dic[@"nickname"],
                                              @"sex"       : strSex,
                                              @"country"   : [NSString stringWithFormat:@"%ld", country.id],
                                              @"countryName" : country.en_name.length > 0 ? country.en_name : @"",
                                              @"birthday"  : birthday.length > 0 ? birthday : @"2000-01-01",
                                              @"unionid"   : dic[@"unionid"]},
                                 @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/registerWeChat"
                                parameters:dictionary
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 验证账户的唯一性

/**
 验证账户的唯一性
 
 @param userName   账号（手机 邮箱）
 @param userType   账号类型 （手机 邮箱）
 @param completion 回调
 */
- (void)verifyAccountSingleWithUserName:(NSString *)userName
                               userType:(NSString *)userType
                             completion:(CompleteBlock)completion
{
    NSDictionary * dic = @{@"params": @{@"userName": userName,
                                        @"userType": userType},
                           @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/checkUser"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(responseObject, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 用户登录

/**
 token 登录

 @param token      token
 @param completion 回调
 */
- (void)loginWithToken:(NSString *)token
            completion:(CompleteBlock)completion
{
    [self loginWithType:@"1" userType:@"" user:@"" password:@"" userId:[NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId] token:token accountType:@"" completion:^(id object, ErrorModel *error) {
        if (error) {
            completion(nil, error);
        }
        else {
            completion(object, nil);
        }
    }];
}

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
           completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"type"      : type,
                                       @"userType"  : userType,
                                       @"user"      : user.length > 0     ? user     : @"",
                                       @"password"  : password.length > 0 ? password : @"",
                                       @"userId"    : userId.length > 0   ? userId   : @"",
                                       @"accountType": accountType,
                                       @"token"     : token.length  > 0   ? token    : @"",
                                       @"system"    : @"1",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/login"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     responseObject = [responseObject mj_JSONObject];
                                     responseObject = [responseObject firstObject];
                                     
                                     UserModel *user = [UserModel mj_objectWithKeyValues:responseObject[@"user"]];
                                     [UserRequest sharedInstance].user  = user;
                                     [UserRequest sharedInstance].token = responseObject[@"token"];
                                     [[UserRequest sharedInstance] saveCache];
                                     [self fk_postNotification:kNotificationUserLogin];
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 微信登录
 
 @param unionid     微信返回的 unionid
 @param completion  回调
 */
- (void)loginWithWeChatUnionid :(NSString *)unionid
                     completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"unionid"   : unionid,
                                       @"imei"      : @"",
                                       @"deviceName": @"",
                                       @"system"    : @"",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/loginWeChat"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     responseObject = [responseObject mj_JSONObject];
                                     responseObject = [responseObject firstObject];
                                     completion(responseObject, nil);
                                 }
                             }];
}



/**
 退出登录
 
 @param completion 回调
 */
- (void)logoutWithCompletion:(CompleteBlock)completion
{
    // 记录退出时间
    NSString *country = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_CurrentCountry];
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"loginadd": country.length > 0 ? country : @"中国",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/logout"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

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
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"type"    : type,
                                       @"num"     : account,
                                       @"areacode": [NSString stringWithFormat:@"%@", areacode]
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/modifyPhoneOrEmail"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 发送手机验证码

/**
 发送手机验证码
 
 @param phone      手机号
 @param areacode   国家码
 @param completion 回调
 */
- (void)sendPhoneCodeWithPhone:(NSString *)phone
                      areacode:(NSString *)areacode
                    completion:(CompleteBlock)completion
{
    if ([areacode hasPrefix:@"+"]) {
        areacode = [areacode substringFromIndex:1];
    }
    NSDictionary *dic = @{@"params": @{@"userId"   : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"areacode" : areacode.length > 0 ? areacode : [NSString stringWithFormat:@"%ld", self.user.areacode],
                                       @"phone"    : phone,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/phoneVerification"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}


#pragma mark - 发送邮箱验证码

/**
 发送邮箱验证码
 
 @param email      邮箱
 @param completion 回调
 */
- (void)sendEmailCodeWithEmail:(NSString *)email
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"email" : email,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/emailVerification"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

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
                completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId" : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"account": account,
                                       @"verifi" : verifi.length > 0 ? verifi : @"",
                                       @"type"   : type,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/verification"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

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
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", userId > 0 ? userId : [UserRequest sharedInstance].user.userId],
                                       @"type"    : type,
                                       @"password": password},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/modifyPassword"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

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
                       completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userName" : account,
                                       @"userType" : [NSString stringWithFormat:@"%ld", accountType],
                                       @"areacode" : areacode,
                                       @"password" : password
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/forgetPassword"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}


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
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"     : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"name"       : name.length  > 0      ? name       : @"",
                                       @"address"    : address.length > 0    ? address    : @"",
                                       @"sex"        : sex.length > 0        ? sex        : @"",
                                       @"language"   : language.length > 0   ? language   : @"",
                                       @"country"    : country.length > 0    ? country    : @"",
                                       @"learnYears" : learnYears.length > 0 ? learnYears  : @"0",
                                       @"interest"   : interest.length > 0   ? interest   : @"",
                                       @"birthday"   : birthday.length > 0   ? birthday   : @"",
                                       @"iconUrl"    : iconUrl.length > 0    ? iconUrl    : @"",
                                       @"school"     : school.length > 0     ? school     : @"",
                                       @"countryName": countryName.length > 0? countryName: @"",
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/updatelInformation"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];                                               
}

#pragma mark - 上传图片

/**
 上传图片
 
 @param imgInfo     图片
 @param completion  回调
 */
- (void)postImageWithImageInfo:(NSString *)imgInfo
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId" : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"pic"    : imgInfo,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/uploadPictures"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 用户阅历分享

/**
 用户阅历分享
 
 @param completion 回调
 */
- (void)shareReadHistoryWithCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", self.user.userId]},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"read/shareReadHistory"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 卡券

/**
 卡密兑换
 
 @param exchange 卡密
 @param completion 回调
 */
- (void)exchangeWithExchangeId:(NSString *)exchange
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"exchange": exchange,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/exchange"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 获取所有的卡券
 
 @param completion 回调
 */
- (void)getAllTicketesWithCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId]},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"cardCouponsInfo/fullCouponActivities"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 获取我的卡券
 
 @param completion 回调
 */
- (void)getMyTicketsWithCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId]},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"cardCouponsInfo/getUserFullminusCard"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 领券中心领取卡券
 
 @param ticketId    卡券 id
 @param completion  回调
 */
- (void)getTicketWithTicketId:(NSInteger)ticketId
                   completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"seqId"   : [NSString stringWithFormat:@"%ld", ticketId],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"cardCouponsInfo/receiveFullCouponActivities"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 通过 cdkey 获取卡券
 
 @param code       cdkey
 @param completion 回调
 */
- (void)getTicketWithCode:(NSString *)code
                     type:(ENUM_TicketType)type
               completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"cardNum" : code,
                                       @"type"    : [NSString stringWithFormat:@"%ld", type]
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"cardCouponsInfo/verifyCart"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

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
                                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"seqId"   : ticketType,
                                       @"page"    : [NSString stringWithFormat:@"%ld", page],
                                       @"length"  : [NSString stringWithFormat:@"%ld", length],
                                       @"sort"    : [NSString stringWithFormat:@"%ld", sort],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"cardCouponsInfo/selectFullCouponBooks"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 设置阅读历史可见

/**
 设置阅读历史可见
 
 @param canBrowe   是否可以查看
 @param completion 回调
 */
- (void)updateUserInfoCanBrowse:(NSString *)canBrowe
                     completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"canview" : canBrowe
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/updateCanView"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {

                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 获取虚拟币消费记录列表

/**
 获取虚拟币消费记录列表
 
 @param page       第几页
 @param completion 回调
 */
- (void)getVirtualCurrencyListWithPage:(NSString *)page
                            completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"length"  : [NSString stringWithFormat:@"%ld", cListNumber_10],
                                       @"page"    : page,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/selectVirtualCurrencyRecord"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 获取积分获取及消费列表

/**
 获取积分获取及消费列表
 
 @param page       第几页
 @param completion 回调
 */
- (void)getIntegralListWithPage:(NSString *)page
                     completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"length"  : [NSString stringWithFormat:@"%ld", cListNumber_10],
                                       @"page"    : page,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/selectScoreRecord"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 获取国家

/**
 获取国家列表
 
 @param completion 回调
 */
- (void)getCountrysComplention:(CompleteBlock)completion
{
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/selectCountry"
                                parameters:nil
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}
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
                       completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"       : [NSString stringWithFormat:@"%ld", self.user.userId],
                                       @"message"      : message,
                                       @"phoneModel"   : phoneModel,
                                       @"mobileSystem" : mobileSystem,
                                       @"appVersion"   : appversion,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"message/userFeedback"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

@end
