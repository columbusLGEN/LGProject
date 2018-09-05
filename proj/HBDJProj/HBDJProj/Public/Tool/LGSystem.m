//
//  LGSystem.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSystem.h"

static NSString * const appVersion = @"appVersion";

@implementation LGSystem

- (void)openAppStorePage{
    
}

/// MARK: 检查版本
- (void)getAppStoreVersion{
//    https://itunes.apple.com/lookup?id=
    NSString *url = [@"https://itunes.apple.com/cn/lookup?bundleId=" stringByAppendingString:[NSBundle mainBundle].bundleIdentifier];
    [LGNetworkManager.sharedInstance sendPOSTRequestWithUrl:url param:nil completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"response: %@",response);
//        NSLog(@"responseObject: %@",responseObject);
//        NSLog(@"error: %@",error);
        
//    responseObject: {
//        resultCount = 0;
//        results =     (
//        );
//    }
        
    }];
}

/// 该方法可以判定是否给用户展示 新版本的特性
- (void)checkAppVersion{
    // 获取app version
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = infoDict[@"CFBundleShortVersionString"];
    
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
