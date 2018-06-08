//
//  DJUserInteractionMgr.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UserInteractionSuccess)(id successObj);
typedef void(^UserInteractionFailure)(id failureObj);

@interface DJUserInteractionMgr : NSObject


/**
 点赞(取消)/收藏(取消)

 @param seqid 主键id
 @param pcid 点赞id，收藏id
 @param collect YES:收藏; NO:点赞
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)likeCollectWithSeqid:(NSInteger)seqid pcid:(NSInteger)pcid collect:(BOOL)collect type:(DJDataPraisetype)type success:(UserInteractionSuccess)success failure:(UserInteractionFailure)failure;
+ (instancetype)sharedInstance;
@end
