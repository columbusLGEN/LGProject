//
//  DJDiscoveryNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/15.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJDiscoveryNetworkManager.h"
#import "DJNetworkManager.h"

@implementation DJDiscoveryNetworkManager

//    frontUserCollections/add -- 提问收藏

- (void)frontQuestionanswer_updateWithQAId:(NSInteger)qaid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    [self sendPOSTRequestWithiName:@"frontQuestionanswer/update" param:@{@"seqid":[NSString stringWithFormat:@"%ld",qaid]} success:success failure:failure];
}

- (void)frontUgc_selectmechanismWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
/**
 //ugctype:
 //    1党员舞台
 //    2思想汇报
 //    3述职述廉
 */
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontUgc/selectmechanism" param:@{@"ugctype":@"1"} success:success failure:failure];
}

- (void)frontBranch_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontBranch/select" param:@{} success:success failure:failure];
}

- (void)frontQuestionanswer_selectmechanismWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:@"frontQuestionanswer/selectmechanism" param:@{} success:success failure:failure];
}

- (void)frontIndex_findIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontIndex/findIndex" param:@{} success:success failure:failure];
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
    argu[@"mechanismid"] = [DJUser sharedInstance].mechanismid;
    argu[@"userid"] = [DJUser sharedInstance].userid;
    return argu;
}

CM_SINGLETON_IMPLEMENTION
@end
