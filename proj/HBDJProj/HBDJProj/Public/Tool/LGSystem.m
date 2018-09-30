//
//  LGSystem.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSystem.h"

static NSString * const appVersion = @"dj_appVersion";
static NSString * const app_store_version = @"dj_app_store_version";
static NSString * const djAppId = @"1406214648";

@implementation LGSystem

/// MARK: 检查安装的app 是否为最新版本
- (void)bundleAppVersionCompareAppStoreVersionResult:(void(^)(NSInteger result))compareResult{
    /// 获取应用商店中的版本号
    NSString *appStoreVersion = self.appStoreVersionInSandBox;
    
    /// 获取本地应用bundle的版本号
    NSString *localAppVersion = self.versionInBundle;
    
    NSComparisonResult versionCompareResult = [localAppVersion compare:appStoreVersion];
    
    if (compareResult)compareResult(versionCompareResult);
}

/// MARK: 获取 app store 上应用的版本信息
- (void)getAppStoreVersion{
    NSString *url = [@"https://itunes.apple.com/lookup?id=" stringByAppendingString:djAppId];
    [LGNetworkManager.sharedInstance sendPOSTRequestWithUrl:url param:nil completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSString *AppStoreVersion = nil;
        id results = responseObject[@"results"];
        if ([results isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = results[0];
            AppStoreVersion = dict[@"version"];
        }
        
        if (AppStoreVersion) {
            [NSUserDefaults.standardUserDefaults setObject:AppStoreVersion forKey:app_store_version];
        }
        
    }];
}

/// MARK: 前往 app store
- (void)openAppStorePage{
    NSString * url = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",djAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

/// MARK: 获取本地存储的 从 app store中请求的应用版本信息
- (NSString *)appStoreVersionInSandBox{
    return [NSUserDefaults.standardUserDefaults objectForKey:app_store_version];
}

/// MARK: 获取bundle中的 app version
- (NSString *)versionInBundle{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

/// 该方法可以判定是否给用户展示 新版本的特性
- (void)checkAppVersion{
    // 获取bundle app version
    NSString *currentVersion = self.versionInBundle;
    
    // 获取沙盒中存储的 version
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [defaults objectForKey:appVersion];
    
    if (![currentVersion isEqualToString:localVersion]){
        /// 当前bundle版本和 沙盒中保存的不一样，说明下载了新版本
        [defaults setObject:currentVersion forKey:appVersion];

    }else{// 首页

    }
}

@end
