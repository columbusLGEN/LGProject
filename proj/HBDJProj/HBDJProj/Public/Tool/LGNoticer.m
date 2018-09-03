//
//  LGNoticer.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGNoticer.h"

@implementation LGNoticer

- (void)checkNetworkStatusWithBlock:(void(^)(BOOL notice))noticeBlock {
    
    [LGNetworkManager.sharedInstance checkNetworkStatusWithBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                noticeBlock(NO);
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                noticeBlock(NO);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (DJUser.sharedInstance.WIFI_playVideo_notice == 1) {
                    /// 提醒
                    noticeBlock(YES);
                }else{
                    noticeBlock(NO);
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                noticeBlock(NO);
                break;

        }
    }];
}

@end
