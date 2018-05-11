//
//  LGNetworkAgent.h
//  LGNetworking
//
//  Created by Peanut Lee on 2018/5/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGBaseRequest;

@interface LGNetworkAgent : NSObject

- (NSURLSessionDataTask *)POSTWithRequest:(LGBaseRequest *)request;
/** 添加并发起请求，暂时只有发起请求的共能 */
//- (void)addRequest:(LGBaseRequest *)request;
+ (instancetype)sharedInstance;
@end
