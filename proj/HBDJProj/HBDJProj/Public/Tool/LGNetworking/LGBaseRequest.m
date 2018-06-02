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

- (instancetype)initWithSuccess:(LGRequestSuccess)success failure:(LGRequestFailure)failure networkFailure:(NetworkFailure)networkFailure{
    if (self = [super init]) {
        self.requestSuccess = success;
        self.requestFailure = failure;
        self.networkFailure = networkFailure;
    }
    return self;
}

- (LGRequestMethod)requestMethod{
    return LGRequestMethodPOST;/// 默认返回 post
}
- (NSString *)packageName{
    return @"APMKAFService";
//    return @"/UniversityPressService";
}
- (NSString *)requestUrl{
    return nil;
}
- (id)requestArguments{
    /// TODO: 计算 params 的 md5
//    NSLog(@"self.subParams -- %@",self.subParams);
    return @{@"md5":@"md5",
             @"params":self.subParams
             };
}
- (NSMutableDictionary *)subParams{
    NSDictionary *dict = @{@"imei":@"imei"
                           ,@"imsi":@"imsi"
                           ,@"userid":@"0"
                           };
    NSMutableDictionary *subParams = [NSMutableDictionary dictionaryWithDictionary:dict];
    return subParams;
}
- (LGRequestSerializerType)requestSerializerType{
    /// 默认发送请求的 参数格式为 JSON
    return LGRequestSerializerTypeJSON;
//    return LGRequestSerializerTypeHTTP;
}
- (LGResponseSerializerType)responseSerializerType{
    /// 默认返回JSON
    return LGResponseSerializerTypeJSON;
}

- (void)start{
    [[LGNetworkAgent sharedInstance] addRequest:self];
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
