//
//  DJOnlineNetorkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineNetorkManager.h"
#import "DJUser.h"

// 机构id 180630014315001
// 用户id 63

/** 涉及机构的用户 测试机构id 和 测试用户id */
static NSString * const testjigouid = @"180630014315001";
static NSString * const testjigouUserid = @"63";

@implementation DJOnlineNetorkManager

- (void)frontSubjects_selectTitleDetailWithPortName:(NSString *)portName titleid:(NSInteger)titleid offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
//    frontSubjects/selectTitleDetail
//    frontSubjects/selectTestsDetail
    NSString *iName = [NSString stringWithFormat:@"frontSubjects/select%@Detail",portName];
//    titleid
//    testsid
    NSString *paramKey;
    if ([portName isEqualToString:@"Title"]) {
        paramKey = @"titleid";
    }else{
        paramKey = @"testsid";
    }
    NSDictionary *param = @{paramKey:[NSString stringWithFormat:@"%ld",(long)titleid]};
    [self commenPOSTWithOffset:offset length:100 sort:0 iName:iName param:param success:success failure:failure];
}

- (void)frontSubjects_selectWithPortName:(NSString *)portName offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    /// 题库列表        frontSubjects/selectTitle
    /// 测试题库列表     frontSubjects/selectTests
    NSString *iName = [@"frontSubjects/select" stringByAppendingString:portName];
    NSDictionary *param = @{};
    [self commenPOSTWithOffset:offset length:10 sort:0 iName:iName param:param success:success failure:failure];
}

- (void)frontVotes_addWithVoteid:(NSInteger)voteid votedetailid:(NSArray *)votedetailid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure {
    NSDictionary *param = @{@"voteid":[NSString stringWithFormat:@"%ld",(long)voteid],
                            @"votedetailid":[votedetailid componentsJoinedByString:@","]};
    [self sendPOSTRequestWithiName:@"frontVotes/add" param:param success:success failure:failure];
}


- (void)frontVotes_selectDetailWithVoteid:(NSInteger)voteid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"voteid":[NSString stringWithFormat:@"%ld",(long)voteid]};
    [self sendPOSTRequestWithiName:@"frontVotes/selectDetail" param:param success:success failure:failure];
}

- (void)frontVotes_selectWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontVotes/select" param:@{} success:success failure:failure];
}

- (void)frontUgcWithType:(DJOnlineUGCType)ugcType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"ugctype":[NSString stringWithFormat:@"%lu",(unsigned long)ugcType]};
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontUgc/selectmechanism" param:param success:success failure:failure];
}

- (void)frontSessionsWithSessiontype:(NSInteger)sessionType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    NSDictionary *param = @{@"sessiontype":[NSString stringWithFormat:@"%ld",(long)sessionType]};
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontSessions/select" param:param success:success failure:failure];
}

- (void)frontThemesWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:offset length:length sort:0 iName:@"frontThemes/select" param:@{} success:success failure:failure];
}
- (void)frontUserinfoSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontUserinfo/selectListUser" param:@{} success:success failure:failure];
}

- (void)frontUgc_addWithFormData:(NSMutableDictionary *)formDict ugctype:(NSInteger)ugctype filetype:(NSInteger)filetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    formDict[@"ugctype"] = [NSString stringWithFormat:@"%ld",(long)ugctype];
    formDict[@"filetype"] = [NSString stringWithFormat:@"%ld",(long)filetype];
    [self sendPOSTRequestWithiName:@"frontUgc/add" param:formDict success:success failure:failure];
}

- (void)addSessionsWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontSessions/add" param:formDict success:success failure:failure];
}

- (void)addThemeWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self sendPOSTRequestWithiName:@"frontThemes/add" param:formDict success:success failure:failure];
}

- (void)onlineHomeConfigSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self commenPOSTWithOffset:0 length:10 sort:0 iName:@"mechanism/select" param:@{} success:success failure:failure];
}

- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    [[DJNetworkManager sharedInstance] uploadImageWithLocalFileUrl:localFileUrl uploadProgress:progress success:success failure:failure];
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
    argu[@"mechanismid"] = testjigouid;// [DJUser sharedInstance].mechanismid
    argu[@"userid"] = testjigouUserid;//[DJUser sharedInstance].userid;
    return argu;
}

CM_SINGLETON_IMPLEMENTION
@end
