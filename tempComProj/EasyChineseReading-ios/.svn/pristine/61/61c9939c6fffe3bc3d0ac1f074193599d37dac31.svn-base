//
//  ECRHTTPSessionManager.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

typedef void(^ECRLEHTTPSuccess)(id responseObject);
typedef void(^ECRLEHTTPFailure)(NSError *error);

typedef NS_ENUM(NSUInteger, ECRHTTPRequestMethod) {
    ECRHTTPRequestMethodGet,
    ECRHTTPRequestMethodPost,
};

#import <Foundation/Foundation.h>

@interface ECRHTTPSessionManager : NSObject

// 1016
- (void)POSTWithInterface:(NSString *)interface param:(id)param success:(ECRLEHTTPSuccess)success failure:(ECRLEHTTPFailure)failure;

+ (instancetype)sharedManager;

@end
