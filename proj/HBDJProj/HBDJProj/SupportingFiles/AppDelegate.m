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
/// TODO: 跳转到指定页面
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//    url.scheme;
//    url.query;
//    return YES;
//}


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

#pragma mark - 私有方法
- (void)baseConfigWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    self.window.rootViewController = [LIGMainTabBarController new];
    [self.window makeKeyAndVisible];
    
    [IFlySetting showLogcat:NO];
    //Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", iFlyAppid];
    [IFlySpeechUtility createUtility:initString];
    
    [[LGDevice sharedInstance] lg_currentDeviceType];
}


@end
