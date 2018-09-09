//
//  DJUserInteractionMgr.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 用户交互管理者

#import <Foundation/Foundation.h>

@class DJDataBaseModel;

typedef void(^UserInteractionSuccess)(id successObj);
typedef void(^UserInteractionFailure)(id failureObj);

typedef void(^UserLikeCollectSuccess)(NSInteger cbkid,NSInteger cbkCount);

@interface DJUserInteractionMgr : NSObject

- (void)dj_handlePushMsgClickWithUserInfo:(NSDictionary *)userinfo;

/**
 点赞(取消)/收藏(取消)

 @param model 模型
 @param collect YES:收藏; NO:点赞
 @param type 数据类型，参照枚举值 DJDataPraisetype
 @param success 成功
 @param failure 回调
 */
- (NSURLSessionTask *)likeCollectWithModel:(DJDataBaseModel *)model collect:(BOOL)collect type:(DJDataPraisetype)type success:(UserLikeCollectSuccess)success failure:(UserInteractionFailure)failure;


+ (instancetype)sharedInstance;
@end
