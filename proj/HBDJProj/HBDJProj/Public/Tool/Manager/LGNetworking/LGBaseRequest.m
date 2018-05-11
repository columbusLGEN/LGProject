//
//  LGBaseRequest.m
//  NetDemo
//
//  Created by Peanut Lee on 2018/5/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseRequest.h"
#import "LGNetworkAgent.h"

@interface LGBaseRequest ()


@end

@implementation LGBaseRequest

- (LGRequestMethod)requestMethod{
    return LGRequestMethodPOST;/// 默认返回 post
}
- (NSString *)packageName{
    return @"/UniversityPressService";
}
- (NSString *)requestUrl{
    return nil;
}
- (id)requestArguments{
    /// TODO: 计算 params 的 md5
    return @{@"md5":@"md5",
             @"params":self.subParams
             };
}
- (id)subParams{
    return nil;
}

- (void)start{
    [[LGNetworkAgent sharedInstance] POSTWithRequest:self];
//    [[LGNetworkAgent sharedInstance] addRequest:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestSuccess = ^(id responseObject) {
            NSLog(@"base request responseObject -- %@",responseObject);
            /// 请求成功
            
            /// 或者，请求接口失败
            
        };
        self.networkFailure = ^(NSError *error) {
            /// 请求失败（接口之外的错误）
          NSLog(@"base request error -- %@",error);
        };
    }
    return self;
}

/// 增加 自定义 request
//buildCustomUrlRequest

/// 获取 task 的 state 等属性
//- (void)temp_func{/// 
//    self.requestTask.state;
//    self.requestTask.response;
//    self.requestTask.currentRequest;
//}

@end
