//
//  TaskRequest.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseNetRequest.h"

@interface TaskRequest : BaseNetRequest

#pragma mark ========== 任务相关网络请求 ==========

CM_SINGLETON_INTERFACE(TaskRequest)

#pragma mark - 我的任务接口

/**
 我的任务

 @param completion 回调
 */
- (void)getTaskListWithCompletion:(CompleteBlock)completion;

#pragma mark - 读书任务

/**
 获取推荐列表
 
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getRecommendListWithPage:(NSInteger)page
                          length:(NSInteger)length
                      completion:(CompleteBlock)completion;

/**
 获取推荐详情
 
 @param shareBatchId 推荐 id
 @param completion   回调
 */
- (void)getRecommendDetailWithShareBatchId:(NSInteger)shareBatchId
                                completion:(CompleteBlock)completion;

/**
 获取授权列表
 
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getImpowerListWithPage:(NSInteger)page
                        length:(NSInteger)length
                    completion:(CompleteBlock)completion;

/**
 获取授权详情
 
 @param grantBatchId 推荐 id
 @param completion   回调
 */
- (void)getImpowerDetailWithGrantBatchId:(NSInteger)grantBatchId
                              completion:(CompleteBlock)completion;

#pragma mark - 查询任务状态

/**
 查询任务状态

 @param taskType   类型(1 每日 2 长期 3 一次性 0 全部)
 @param completion 回调
 */
- (void)getTaskStatusWithTaskType:(NSString *)taskType
                       completion:(CompleteBlock)completion;

#pragma mark - 领取任务奖励

/**
 领取任务奖励
 
 @param task        任务
 @param completion  回调
 */
- (void)getTaskAwardWithTask:(TaskModel *)task
                  completion:(CompleteBlock)completion;

@end
