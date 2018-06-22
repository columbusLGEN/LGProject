//
//  DJUserNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUserNetworkManager.h"
#import "DJUser.h"

@interface DJUserNetworkManager ()


@end

@implementation DJUserNetworkManager

- (void)userLogoutSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{};
    [self sendTableWithiName:@"/frontUserinfo/logout" param:param needUserid:YES success:success failure:failure];
}
- (void)userLoginWithTel:(NSString *)tel pwd_md5:(NSString *)pwd_md5 success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    /**
     type
     0: token登陆
     1: 密码登陆
     token登录应该去掉，因为token是登陆成功服务器返回的，所以，这里的接口设计是错误的
     */
    
    NSDictionary *param = @{@"phone":tel
                            ,@"password":pwd_md5
                            };
    [self sendTableWithiName:@"/frontUserinfo/login" param:param needUserid:NO success:success failure:failure];
}
- (void)userActivationWithTel:(NSString *)tel oldPwd:(NSString *)oldPwd pwd:(NSString *)pwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"phone":tel,
                            @"oldpassword":oldPwd,
                            @"password":pwd
                            };
    [self sendTableWithiName:@"/frontUserinfo/activation" param:param needUserid:NO success:success failure:failure];
}

- (void)sendTableWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendTableWithiName:iName param:param needUserid:needUserid success:success failure:failure];
}

CM_SINGLETON_IMPLEMENTION
@end
