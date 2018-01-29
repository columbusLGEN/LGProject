//
//  AppDelegate.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "AppDelegate.h"

#import <AlipaySDK/AlipaySDK.h> // alipay

#import <UMCommon/UMCommon.h>        // 友盟-基础
#import <UMAnalytics/MobClick.h>     // 友盟-统计
#import <UMPush/UMessage.h>          // 友盟-推送
#import <UserNotifications/UserNotifications.h> // 推送系统库

#import "WXApi.h" // 微信登录

#import "FirstLaunchCountryVC.h" // 首次加载app

#import "CLMTabBarController.h"  // app框架
#import "ECRDownloadManager.h"   // 下载书籍
#import "ECRHypermediaManager.h"
#import "ECRMentionBoy.h"

#import "UserMessageVC.h"
#import "ECRSubjectController.h"
#import "ECRThematicModel.h"
#import "ECRBaseWkViewController.h"

@interface AppDelegate ()<
WXApiDelegate,
UNUserNotificationCenterDelegate
>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:Screen_Bounds];
    // 首次打开 app 配置相关信息
    if (![[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_NotFirstTime]) {
        // 引导页
        [self loadFirstLaunchView];
    }
    else {
        [self baseSettingWithOptions:application];
    }
    // 发送崩溃日志 
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    // 微信开发者ID
    [WXApi registerApp:WX_App_ID];
    // 初始化本地下载路径
    [ECRDownloadManager initLocalFilePath];
    [ECRHypermediaManager lg_initLocalFile];
    
    [SDImageCache sharedImageCache];
    
    // 获取 app 语言及设置语言
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self configLanguage];
        [self baseSettingWithOptions:application];
    }];
    
    [self fk_observeNotifcation:kNotificationCloseLaunch usingBlock:^(NSNotification *note) {
        [self baseSettingWithOptions:application];
//        [self.window.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:.35f];
    }];
    
    // 配置友盟推送、统计等
    [self configUMApplication:application didFinishLaunchingWithOptions:launchOptions];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [ECRMentionBoy loadTipsForOneHour];
//    });
    // TODO: 登录拉取消息的接口暂时发现没意义, 个人信息界面会获取一次
//    if ([UserRequest sharedInstance].online) {
//        [self getNewMessage];
//    }
    
    [self deviceUUID];
    return YES;
}

#pragma mark - 打开第三方

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    BOOL result = [WXApi handleOpenURL:url delegate:self];
//    if (result == NO && [url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        result = YES;
//    }
//    return result;
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [WXApi handleOpenURL:url delegate:self];

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"appDele: alipay result = %@",resultDic);
        }];
        result = YES;
    }
    return result;
}

#pragma mark - 推送通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage setAutoAlert:NO];
    // 友盟推送 统计点击数
    [UMessage didReceiveRemoteNotification:userInfo];
}
// 静默推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    // 友盟推送 统计点击数
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];

    NSLog(@"device_token : %@", [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]);
}

// iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
//        [self fk_postNotification:kNotificationPush object:nil userInfo:userInfo];
        [UMessage didReceiveRemoteNotification:userInfo];
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LOCALIZATION(@"消息") message:LOCALIZATION(@"请选择") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:LOCALIZATION(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self pushWithUserInfo:userInfo];
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZATION(@"取消") style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:alertAction];
//        [alertController addAction:cancelAction];
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        //必须加这句代码
    }
    else {
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

// iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
//        [self fk_postNotification:kNotificationPush object:nil userInfo:userInfo];
        [self pushWithUserInfo:userInfo];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    else {
        //应用处于后台时的本地推送接受
    }
}

// 检查是否打开了推送开关
//- (void)checkUserNotificationSetting
//{
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
//        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
//        if (UIUserNotificationTypeNone == setting.types) {
//            NSLog(@"推送关闭");
//            // 跳转设置推送界面
////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }
//    }
//    else {
//        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        if(UIRemoteNotificationTypeNone == type){
//            NSLog(@"推送关闭");
//        }
//    }
//}

#pragma mark - 初始化
#pragma mark 设置语言
- (void)configLanguage
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]];
        // 获取系统语言
//        NSArray *languages = [NSLocale preferredLanguages];
//        NSString *language = [languages objectAtIndex:0];
//        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
//            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
//        }
//        else{
//            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
//        }
    }
}

#pragma mark 设置主界面
- (void)baseSettingWithOptions:(UIApplication *)application{
    
    // 我们要把系统windown的rootViewController替换掉
    CLMTabBarController *tab = [[CLMTabBarController alloc] init];
    self.window.rootViewController = tab;
    // 跳转到设置页
//        tab.selectedIndex = 2;
    [self.window makeKeyAndVisible];
    
    [self getUserInfo];
}

#pragma mark 获取用户信息

- (void)getUserInfo
{
    if ([[UserRequest sharedInstance] online]) {
        [[UserRequest sharedInstance] getUserInfoWithCompletion:^(id object, ErrorModel *error) {

        }];
    }
}

#pragma mark 首次打开app

- (void)loadFirstLaunchView
{
    FirstLaunchCountryVC *countryVC = [FirstLaunchCountryVC new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:countryVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

#pragma mark 获取最新消息

- (void)getNewMessage
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *lastTime = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:[NSString stringWithFormat:@"%@%ld", CacheKey_MessageTime, [UserRequest sharedInstance].user.userId]];
    [[FriendRequest sharedInstance] getMessageAndShareBookWithStartTime:lastTime endTime:dateString completion:^(id object, ErrorModel *error) {
        if (!error) {
            NSArray *array = [MessageModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                // 最新的消息
                MessageModel *lastMessage = [array firstObject];
                // 将最新一条消息的创建时间缓存为截止时间
                [[CacheDataSource sharedInstance] setCache:lastMessage.emailCreatedTime withCacheKey:[NSString stringWithFormat:@"%@%ld", CacheKey_MessageTime, [UserRequest sharedInstance].user.userId]];
                NSMutableArray *arrCache = [NSMutableArray array];
                NSArray *arrTemp = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:[NSString stringWithFormat:@"%@_%ld", CacheKey_Messages, [UserRequest sharedInstance].user.userId]];
                [arrCache addObjectsFromArray:arrTemp];
                [arrCache addObjectsFromArray:array];
                [[CacheDataSource sharedInstance] setCache:arrCache withCacheKey:[NSString stringWithFormat:@"%@_%ld", CacheKey_Messages, [UserRequest sharedInstance].user.userId]];
            }
        }
    }];
}

#pragma mark 崩溃日志记录

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  当前时间
     */
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *now = [formatter stringFromDate:date];
    
    /**
     *  获取异常崩溃信息
     */
    NSString *name = [exception name];
    NSString *reason = [exception reason];
    NSArray  *callStack = [exception callStackSymbols];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\n崩溃报告:\n%@\n崩溃原因:\n%@\n崩溃日志:\n%@ \n机器型号:\n%@\n系统版本:\n%@\n软件版本:\n%@\n崩溃时间:\n%@"
                         , name                                         // 报告名
                         , reason                                       // 崩溃原因
                         , [callStack componentsJoinedByString:@"\n"]   // 日志详情
                         , [IPhoneVersion deviceName]                   // 设备名
                         , SSystemVersion                               // 设备系统版本
                         , appVersion                                   // App 版本
                         , now];                                        // 当前时间
    
    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    NSMutableString *mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailto:zhaocy@retechcorp.com"];
    [mailUrl appendString:@"?cc=lig@retechcorp.com"];
    [mailUrl appendString:@"&subject=程序崩溃，请配合发送异常报告，谢谢合作！"];
    [mailUrl appendFormat:@"&body=%@", content];
    // 打开地址
    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
}

#pragma mark 配置友盟

- (void)configUMApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 配置友盟SDK产品并并统一初始化
    [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    [UMConfigure initWithAppkey:UM_App_Key channel:@"App Store"];
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    
    // ----- 友盟推送 -----
    //iOS10必须加下面这段代码。配置推送中心
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    center.delegate = self;
    UNAuthorizationOptions authorizationOptions = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [center requestAuthorizationWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    // 检查推送是否有内容
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo){
//        [self fk_postNotification:kNotificationPush object:nil userInfo:userInfo];
        [self pushWithUserInfo:userInfo];
    }
}

#pragma mark - 推送
// 获取推送数据，解析数据后根据数据做后续操作
/**
{
    "policy":{
        "expire_time":"2017-12-31 15:03:46" // 过期时间
    },
    "description":"测试1 任务描述 ",          // 任务描述
    "production_mode":false,                // 正式环境
    "appkey":"5a4451ba8f4a9d30a4000011",    // 项目 在友盟 appkey
    "payload":{
        "aps":{
            "alert":{
                "title":"测试1 主标题 ",     // 主标题
                "subtitle":"测试1 副标题",   // 副标题
                "body":"测试1 内容"          // 内容
            },
            "url":"www.baidu.com",          // 内容链接 "key":"value" // 暂定不使用，使用自定义字段
            "mutable-content":1,
            "category":"123",               // Category ID
            "sound":"default",              // 提示方式
            "badge":1                       // 角标
        },
        "type":"1",                         // 自定义字段 type 消息类型
        "msgId":"2",                        // 自定义字段 msgId 消息内容的id 对应不同数据类型的数据id
        "en_title":"Merry Christmas"        // 自定义字段 en_title 英文标题
        "url":"元宵节书籍5折活动"              // 自定义字段 url 根据type传专题图片或web链接
    },
    "type":"broadcast",
    "timestamp":"1514445685716"
}
*/
- (void)pushWithUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"========== push userInfo %@ ========", userInfo);
    NSDictionary *aps = userInfo[@"aps"];
    if (!aps) { return; }
    NSDictionary *alert = aps[@"alert"];
    if (!alert) { return; }
    NSInteger type = [NSString stringWithFormat:@"%@", aps[@"type"]].integerValue;
    
    UIViewController *rVC = self.window.rootViewController;
    UIViewController *VC = [self getCurrentVCFrom:rVC];
    
    if (type == ENUM_MessageTypeActivity) { // 专题活动
        ECRThematicModel *model = [ECRThematicModel new];
        model.seqid           = [NSString stringWithFormat:@"%@", userInfo[@"msgId"]].integerValue;
        model.templetimg      = [NSString stringWithFormat:@"%@", userInfo[@"url"]];
        model.thematicName    = [NSString stringWithFormat:@"%@", alert[@"title"]];
        model.en_thematicName = [NSString stringWithFormat:@"%@", userInfo[@"en_title"]];
        ECRSubjectController *sbvc = [[ECRSubjectController alloc] init];
        sbvc.viewControllerPushWay = ECRBaseControllerPushWayPush;
        sbvc.model = model;
        [VC.navigationController pushViewController:sbvc animated:YES];
    }
    else if (type == ENUM_MessageTypeUrl) { // url活动
        ECRBaseWkViewController *bwkvc = [ECRBaseWkViewController new];
        bwkvc.URLString = [NSString stringWithFormat:@"%@", aps[@"url"]];
        bwkvc.wkTitle = [NSString stringWithFormat:@"%@", [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? alert[@"title"] : aps[@"en_title"]];
        [VC.navigationController pushViewController:bwkvc animated:YES];
    }
    else if (type == ENUM_MessageTypeUnknow) { // 未定义
        
    }
    else { // 卡券、私信、系统消息
        [VC pushToViewControllerWithClassName:NSStringFromClass([UserMessageVC class])];
    }
}

#pragma mark - 微信登录

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:authResp.code  forKey:WX_CODE];
            [self fk_postNotification:kNotificationWXAccessToken object:authResp.code];
        }
        else {
            [self fk_postNotification:kNotificationAlertError object:@"授权失败"];
        }
    }
}

#pragma mark - 进入前台（活跃）

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UserRequest sharedInstance] loginWithToken:[UserRequest sharedInstance].token completion:^(id object, ErrorModel *error) {
        
    }];
}

#pragma mark - 进入后台（挂起）

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([UserRequest sharedInstance].online) {
        NSString *country = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_CurrentCountry];
        [[UserRequest sharedInstance] logOnlineTimeWithCountry:country completion:^(id object, ErrorModel *error) {
            
        }];
    }
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 禁止横屏

/**
 * 功能：禁止横屏
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

@end
