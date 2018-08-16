//
//  DJUserInteractionMgr.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUserInteractionMgr.h"
#import "DJDataBaseModel.h"

@implementation DJUserInteractionMgr

- (NSURLSessionTask *)likeCollectWithModel:(DJDataBaseModel *)model collect:(BOOL)collect type:(DJDataPraisetype)type success:(UserLikeCollectSuccess)success failure:(UserInteractionFailure)failure{
    
    /// TODO: 由于多个页面有点赞收藏的交互，因此需要把该方法中公共的逻辑再封装一次，以便不同的页面调用
    
    /// -----公共逻辑
    NSInteger param_id;
    BOOL addordel;/// 区分添加还是删除
    
    NSInteger pcid;
    
    /// 收藏，pcid 为 collectionid；点赞 pcid 为 praiseid
    if (collect) {
        pcid = model.collectionid;
    }else{
        pcid = model.praiseid;
    }
    
    /// 添加, param_id 为model主键id；删除，param_id为model的 收藏id（或者点赞id）
    if (pcid == 0) {
        /// 添加
        addordel = NO;
        param_id = model.seqid;
    }else{
        /// 删除
        addordel = YES;
        param_id = pcid;
    }
    /// -----公共逻辑
    
    return [DJHomeNetworkManager homeLikeSeqid:[NSString stringWithFormat:@"%ld",param_id] add:addordel praisetype:type success:^(id responseObj) {
        
        /// -----公共逻辑
        NSDictionary *dict = responseObj;
        if ([[[dict allKeys] firstObject] isEqualToString:@"praiseid"]) {
            NSLog(@"点赞 -- %@",responseObj);
            NSInteger praiseid = [responseObj[@"praiseid"] integerValue];
            model.praiseid = praiseid;
            if (praiseid != 0) {
                model.praisecount += 1;
            }else{
                model.praisecount -= 1;
            }
            if (success) success(praiseid,model.praisecount);
        }else{
            NSLog(@"收藏 -- %@",responseObj);
            NSInteger collectionid = [responseObj[@"collectionid"] integerValue];
            model.collectionid = collectionid;
            if (collectionid != 0) {
                model.collectioncount += 1;
            }else{
                model.collectioncount -= 1;
            }
            if (success) success(collectionid,model.collectioncount);
        }
        /// -----公共逻辑
        
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
