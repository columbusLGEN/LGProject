//
//  DJOnlineNetorkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineNetorkManager.h"
#import "DJUser.h"

static NSString * const testjigouid = @"180607092010001";

@implementation DJOnlineNetorkManager

/// TODO: 机构id 统一添加



- (void)frontVotes_addWithVoteid:(NSInteger)voteid votedetailid:(NSArray *)votedetailid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure {
    NSDictionary *param = @{@"voteid":[NSString stringWithFormat:@"%ld",voteid],
                            @"votedetailid":[votedetailid componentsJoinedByString:@","]};
    [self sendPOSTRequestWithiName:@"frontVotes/add" param:param success:success failure:failure];
}


- (void)frontVotes_selectDetailWithVoteid:(NSInteger)voteid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"voteid":[NSString stringWithFormat:@"%ld",voteid]};
    [self sendPOSTRequestWithiName:@"frontVotes/selectDetail" param:param success:success failure:failure];
}

- (void)frontVotes_selectWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"mechanismid":testjigouid};
//    NSDictionary *param = @{@"mechanismid":DJUser.sharedInstance.mechanismid};
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontVotes/select" param:param success:success failure:failure];
}

- (void)frontUgcWithType:(DJOnlineUGCType)ugcType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"mechanismid":DJUser.sharedInstance.mechanismid
                            ,@"ugctype":[NSString stringWithFormat:@"%ld",ugcType]};
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontUgc/selectmechanism" param:param success:success failure:failure];
}

- (void)frontSessionsWithSessiontype:(NSInteger)sessionType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    NSDictionary *param = @{@"mechanismid":testjigouid,
                            @"sessiontype":[NSString stringWithFormat:@"%ld",sessionType],
                            @"userid":@"72"
                            };
    //    NSDictionary *param = @{@"mechanismid":DJUser.sharedInstance.mechanismid};
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontSessions/select" param:param success:success failure:failure];
}

- (void)frontThemesWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    /// 支部id
    /// 测试用 机构id 180630014315001
    NSDictionary *param = @{@"mechanismid":testjigouid};
//    NSDictionary *param = @{@"mechanismid":DJUser.sharedInstance.mechanismid};
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontThemes/select" param:param success:success failure:failure];
}
- (void)frontUserinfoSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"mechanismid":testjigouid};
    [self sendPOSTRequestWithiName:@"frontUserinfo/selectListUser" param:param success:success failure:failure];
}

- (void)addSessionsWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    formDict[@"mechanismid"] = [DJUser.sharedInstance mechanismid];
    [self sendPOSTRequestWithiName:@"frontSessions/add" param:formDict success:success failure:failure];
}

- (void)addThemeWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    formDict[@"mechanismid"] = [DJUser.sharedInstance mechanismid];
    [self sendPOSTRequestWithiName:@"frontThemes/add" param:formDict success:success failure:failure];
}

- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    [[DJNetworkManager sharedInstance] uploadImageWithLocalFileUrl:localFileUrl uploadProgress:progress success:success failure:failure];
}

- (void)onlineHomeConfigSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"mechanismid":[DJUser sharedInstance].mechanismid};
    [self commenPOSTWithOffset:0 length:10 sort:0 iName:@"mechanism/select" param:param success:success failure:failure];
}

/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendPOSTRequestWithiName:iName param:param success:success failure:failure];
}
- (void)commenPOSTWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort iName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] commenPOSTWithOffset:offset length:length sort:sort iName:iName param:param success:success failure:failure];
}

CM_SINGLETON_IMPLEMENTION
@end
