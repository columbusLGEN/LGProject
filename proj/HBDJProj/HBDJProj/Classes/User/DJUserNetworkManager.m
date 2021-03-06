//
//  DJUserNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUserNetworkManager.h"
#import "DJUser.h"

static NSString * const newpassword_key = @"newpassword";
static NSString * const phone_key = @"phone";
static NSString * const password_key = @"password";

@interface DJUserNetworkManager ()


@end

@implementation DJUserNetworkManager

- (void)frontUserNotice_selectUnReadNumSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontUserNotice/selectUnReadNum" param:@{} success:success failure:failure];
    
}

- (void)frontIntegralGrade_addWithIntegralid:(DJUserAddScoreType)integralid completenum:(double)completenum success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"integralid":@(integralid).stringValue,
                            @"completenum":[NSString stringWithFormat:@"%.1f",completenum]};
    [self sendPOSTRequestWithiName:@"frontIntegralGrade/add" param:param success:success failure:failure];
}

- (void)frontBranch_selectDetailWithSeqid:(NSInteger)seqid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{seqid_key:@(seqid).stringValue};
    [self sendPOSTRequestWithiName:@"frontBranch/selectDetail" param:param success:success failure:failure];
}

- (void)frontQuestionanswer_selectDetailWithSeqid:(NSInteger)seqid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure {
    NSDictionary *param = @{seqid_key:@(seqid).stringValue};
    [self sendPOSTRequestWithiName:@"frontQuestionanswer/selectDetail" param:param success:success failure:failure];
}

- (void)frontUserNotice_updateWithId:(NSInteger)seqid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure {
//    @"isread":@(YES) 接口多余参数,不传
    NSDictionary *param = @{seqid_key:@(seqid)};
    [self sendPOSTRequestWithiName:@"frontUserNotice/update" param:param success:success failure:failure];
}

- (void)frontUserNotice_deleteWithSeqids:(NSString *)seqids success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontUserNotice/delete" param:@{seqid_key:seqids} success:success failure:failure];
}

- (void)frontUgc_deleteWithSeqids:(NSString *)seqids success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontUgc/delete" param:@{seqid_key:seqids} success:success failure:failure];
}

- (void)frontUserCollections_deleteBatchWithCoids:(NSString *)coids success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    [self sendPOSTRequestWithiName:@"frontUserCollections/deleteBatch" param:@{seqid_key:coids} success:success failure:failure];
}

- (void)frontUserinfo_updateWithInfoDict:(NSDictionary *)infoDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"/frontUserinfo/update" param:infoDict success:success failure:failure];
}

- (void)frontIntegralGrade_selectTaskSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontIntegralGrade/selectTask" param:@{} success:success failure:failure];
}

- (void)frontIntegralGrade_selectIntegralSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontIntegralGrade/selectIntegral" param:@{} success:success failure:failure];
}

- (void)frontIntegralGrade_selectSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontIntegralGrade/select" param:@{} success:success failure:failure];
}

- (void)frontFeedback_addWithTitle:(NSString *)title success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"title":title};
    [self sendPOSTRequestWithiName:@"frontFeedback/add" param:param success:success failure:failure];
}

- (void)frontFeedback_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontFeedback/select" param:@{} success:success failure:failure];
}

- (void)frontFeedback_selectIndexWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontFeedback/selectIndex" param:@{} success:success failure:failure];
}

- (void)frontUgc_selectWithUgctype:(DJOnlineUGCType)ugctype offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{ugctype_key:[NSString stringWithFormat:@"%ld",ugctype]};
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontUgc/select" param:param success:success failure:failure];
}

- (void)frontUserCollections_selectWithType:(DJMCType)type offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"type":[NSString stringWithFormat:@"%ld",type]};
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontUserCollections/select" param:param success:success failure:failure];
}

- (void)frontUserNotice_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontUserNotice/select" param:@{} success:success failure:failure];
    
}


- (void)frontQuestionanswer_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontQuestionanswer/select" param:@{} success:success failure:failure];
}

- (void)frontUserinfo_selectSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    [self sendPOSTRequestWithiName:@"frontUserinfo/select" param:@{} success:success failure:failure];
}
- (void)userUpdatePwdWithOld:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{newpassword_key:newPwd,
                            password_key:oldPwd};
    [self sendTableWithiName:@"frontUserinfo/updatePwd" param:param needUserid:YES success:success failure:failure];
}

- (void)userForgetChangePwdWithPhone:(NSString *)phone newPwd:(NSString *)newPwd oldPwd:(NSString *)oldPwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{phone_key:phone,
                            newpassword_key:newPwd,
                            password_key:oldPwd
                            };
    [self sendTableWithiName:@"frontUserinfo/forgetPwd" param:param needUserid:NO success:success failure:failure];
}

- (void)userVerrifiCodeWithPhone:(NSString *)phone code:(NSString *)code success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{phone_key:phone,
                            @"verifi":code
                            };
    [self sendTableWithiName:@"frontUserinfo/checkVerifi" param:param needUserid:NO success:success failure:failure];
    
}
- (void)userSendMsgWithPhone:(NSString *)phone success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{phone_key:phone};
    [self sendTableWithiName:@"frontUserinfo/sendMsg" param:param needUserid:NO success:success failure:failure];
}

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
    
    NSDictionary *param = @{phone_key:tel,
                            password_key:pwd_md5,
                            @"type":@"1" // TODO: Zup_添加类型，1 密码登陆
                            };
    [self sendTableWithiName:@"/frontUserinfo/login" param:param needUserid:NO success:success failure:failure];
}

- (void)userLoginWithToken:(NSString *)token userId:(NSString *)userId success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"userid":userId,
                            @"token":token,
                            @"type":@"0" // TODO: Zup_添加类型，0 token登录
                            };
    [self sendTableWithiName:@"/frontUserinfo/login" param:param needUserid:YES success:success failure:failure];
}

- (void)userActivationWithTel:(NSString *)tel oldPwd:(NSString *)oldPwd pwd:(NSString *)pwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{phone_key:tel,
                            @"oldpassword":oldPwd,
                            password_key:pwd
                            };
    [self sendTableWithiName:@"/frontUserinfo/activation" param:param needUserid:NO success:success failure:failure];
}

- (void)sendTableWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendTableWithiName:iName param:param needUserid:needUserid success:success failure:failure];
}

/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendPOSTRequestWithiName:iName param:[self unitAddMemIdWithParam:param] success:success failure:failure];
}
- (void)commenPOSTWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort iName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    [[DJNetworkManager sharedInstance] commenPOSTWithOffset:offset length:length sort:sort iName:iName param:[self unitAddMemIdWithParam:param] success:success failure:failure];
}
- (NSDictionary *)unitAddMemIdWithParam:(id)param{
    NSMutableDictionary *argu = [NSMutableDictionary dictionaryWithDictionary:param];
    argu[mechanismid_key] = [DJUser sharedInstance].mechanismid;
    argu[userid_key] = [DJUser sharedInstance].userid;
    return argu;
}

NSString *dj_updateUserInfoKey(DJUpdateUserInfoKey infoKey){
    switch (infoKey) {
        case DJUpdateUserInfoKeyName:
            return @"name";
            break;
        case DJUpdateUserInfoKeyImage:
            return @"image";
            break;
        case DJUpdateUserInfoKeyPhone:
            return @"phone";
            break;
        case DJUpdateUserInfoKeyPassword:
            return @"password";
            break;
    }
}

CM_SINGLETON_IMPLEMENTION
@end
