//
//  LGNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// MARK: 通用的请求管理者，可以复用

#import <Foundation/Foundation.h>

typedef void(^LGNetworkCompletion)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error);

@interface LGNetworkManager : NSObject

- (NSURLSessionTask *)taskForPOSTRequestWithUrl:(NSString *)url param:(id)param completionHandler:(nullable LGNetworkCompletion)completionHandler;
- (void)sendPOSTRequestWithUrl:(NSString *)url param:(id)param completionHandler:(LGNetworkCompletion)completionHandler;
+ (instancetype)sharedInstance;
@end
