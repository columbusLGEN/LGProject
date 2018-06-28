//
//  DJOnlineNetorkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineNetorkManager.h"

@implementation DJOnlineNetorkManager

- (void)onlineHomeConfigSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"mechanismid":[DJUser sharedInstance].mechanismid};
    [self sendPOSTRequestWithiName:@"mechanism/select" param:param success:success failure:failure];
}

/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendPOSTRequestWithiName:iName param:param success:success failure:failure];
}

CM_SINGLETON_IMPLEMENTION
@end
