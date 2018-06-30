//
//  AppDelegate.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/3/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "LIGMainTabBarController.h"
#import <iflyMSC/iflyMSC.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

#import "UCLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self baseConfigWithApplication:application launchOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

#pragma mark - 私有方法
- (void)baseConfigWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    
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
    
    /// 确定当前设备
    [[LGDevice sharedInstance] lg_currentDeviceType];
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
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

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

/**
 * 功能：禁止横屏
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


@end
