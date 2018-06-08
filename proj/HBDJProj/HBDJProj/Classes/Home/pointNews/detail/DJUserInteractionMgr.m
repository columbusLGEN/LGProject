//
//  DJUserInteractionMgr.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUserInteractionMgr.h"

@implementation DJUserInteractionMgr

+ (void)likeCollectWithSeqid:(NSInteger)seqid pcid:(NSInteger)pcid collect:(BOOL)collect type:(DJDataPraisetype)type success:(UserInteractionSuccess)success failure:(UserInteractionFailure)failure{
    [[self sharedInstance] likeCollectWithSeqid:seqid pcid:pcid collect:collect type:type success:success failure:failure];
}
- (void)likeCollectWithSeqid:(NSInteger)seqid pcid:(NSInteger)pcid collect:(BOOL)collect type:(DJDataPraisetype)type success:(UserInteractionSuccess)success failure:(UserInteractionFailure)failure{
    NSInteger ID;
    BOOL addordel;
    
    NSString *msg;
    if (collect) {
        msg = @"收藏_collectionid";
    }else{
        msg = @"点赞_praiseid";
    }
    NSLog(@"%@ -- %ld",msg,pcid);
    
    if (pcid == 0) {
        /// 添加
        ID = seqid;
        addordel = NO;
    }else{
        /// 删除
        ID = pcid;
        addordel = YES;
    }
    [DJNetworkManager homeLikeSeqid:[NSString stringWithFormat:@"%ld",ID] add:addordel praisetype:type success:^(id responseObj) {
        if (success) success(responseObj);
    } failure:^(id failureObj) {
        if (failure) failure(failureObj);
    } collect:collect];
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
