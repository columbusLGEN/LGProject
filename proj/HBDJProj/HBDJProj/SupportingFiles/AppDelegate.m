//
//  AppDelegate.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "LIGMainTabBarController.h"
#import "UCLoginViewController.h"
#import "DJUserNetworkManager.h"

#import <iflyMSC/iflyMSC.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>
#import "DJUserInteractionMgr.h"
#import "LGSystem.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>


@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // TODO: Zup_添加token登录
    [self loginWithToken];
    [self baseConfigWithApplication:application launchOptions:launchOptions];
    
    return YES;
}

// 设置系统回调 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

// 通知注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - 私有方法
- (void)baseConfigWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{
    
    /// 配置推送
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    //      NSSet<UNNotificationCategory *> *categories;
    //      entity.categories = categories;
    //    }
    //    else {
    //      NSSet<UIUserNotificationCategory *> *categories;
    //      entity.categories = categories;
    //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    BOOL isProduction = NO;
#ifdef DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif
    
//    NSLog(@"isProduction: %d",isProduction);
    
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAppKey
                          channel:@""
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    
//    027-87679599
//    [NSUserDefaults.standardUserDefaults removeObjectForKey:dj_service_numberKey];
    /// 先放一个默认电话，防止显示异常
    [NSUserDefaults.standardUserDefaults setObject:@"027-87679599" forKey:dj_service_numberKey];
    /// 请求客服电话
    [DJHomeNetworkManager.sharedInstance requestForServiceNumberSuccess:^(id responseObj) {
        NSString *loginnum = responseObj[loginnumKey];
        [NSUserDefaults.standardUserDefaults setObject:loginnum forKey:dj_service_numberKey];
        
    } failure:^(id failureObj) {
        
    }];
    
    /// 获取商定中应用信息
    [LGSystem.new getAppStoreVersion];
    
    if (![DJUser sharedInstance].userid) {
        /// 表明用户还未登录，进入登录控制器
        self.window.rootViewController = [UCLoginViewController navWithLoginvc];
    }else{
        
        /// 加载主控制器之前，初始化用户单利
        [[DJUser sharedInstance] getLocalUserInfo];
        
        self.window.rootViewController = [LIGMainTabBarController new];
    }
    
    [self.window makeKeyAndVisible];
    
    /// 初始化讯飞语音sdk
    [IFlySetting showLogcat:NO];
    //Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", iFlyAppid];
    [IFlySpeechUtility createUtility:initString];
    
    /// 配置友盟分享
//    [self confitUShareSettings];
    [self configUSharePlatforms];

    /// 打开友盟 错误日志收集
    
    
    /// 确定当前设备
    [[LGDevice sharedInstance] lg_currentDeviceType];
}
// TODO: Zup_添加token登录
- (void)loginWithToken
{
    [[DJUser sharedInstance] getLocalUserInfo];
    if (![DJUser sharedInstance].userid || [DJUser sharedInstance].token.length == 0) {
        return;
    }
    
    [[DJUserNetworkManager sharedInstance] userLoginWithToken:[DJUser sharedInstance].token
                                                       userId:[DJUser sharedInstance].userid
                                                      success:^(id responseObj) {
                                                          DJUser *user = [DJUser mj_objectWithKeyValues:responseObj];
                                                          /// 用户信息本地化
                                                          [user keepUserInfo];
                                                          /// 将本地用户信息赋值给单利对象,保证每次用户重新登录之后，都会重新赋值
                                                          [[DJUser sharedInstance] getLocalUserInfo];
                                                      } failure:^(id failureObj) {
                                                          [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
                                                          if ([failureObj isKindOfClass:[NSError class]]) {
                                                              NSLog(@"failure_error: %@",failureObj);
                                                          }
                                                          if ([failureObj isKindOfClass:[NSDictionary class]]) {
                                                              if ([failureObj[@"result"] integerValue] == 6) {
                                                                  [[DJUser sharedInstance] removeLocalUserInfo];
                                                                  [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:isLogin_key];
                                                                  self.window.rootViewController = [UCLoginViewController navWithLoginvc];
                                                                 [self.window presentFailureTips:@"你的账号已经在其他机器登录，请重新登录"];
                                                              } else {
                                                                  NSLog(@"failure_dict: %@",failureObj);
                                                                  NSString *msg = failureObj[@"msg"];
                                                                  [self.window presentFailureTips:msg];
                                                              }
                                                          }
                                                      }];
}

- (void)configUSharePlatforms{
    
    /// 初始化 友盟SDK
    [UMConfigure initWithAppkey:DJUMAppKey channel:@"App Store"];
//    [UMConfigure setLogEnabled:YES];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:DJWexinAppID
                                       appSecret:DJWexinAppSecret
                                     redirectURL:@""];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:DJQQAppID/*设置QQ平台的appID*/
                                       appSecret:DJQQAppKey
                                     redirectURL:@""];
    
//    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3315220764"  appSecret:@"652c4ec4aa22f90c2cbb579a258be2f3" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

}

- (void)confitUShareSettings{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
/// MARK: 当用户点击了推送消息时
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [DJUserInteractionMgr.sharedInstance dj_handlePushMsgClickWithUserInfo:userInfo];
        
        [JPUSHService handleRemoteNotification:userInfo];
        
    }
    completionHandler();  // 系统要求执行这个方法
}

//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSLog(@"messageID: %@,content: %@,extras: %@",messageID,content,extras);
//}

/**
 * 功能：禁止横屏
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


@end
