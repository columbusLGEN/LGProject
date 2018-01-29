//
//  TaskRequest.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "TaskRequest.h"

@implementation TaskRequest

CM_SINGLETON_IMPLEMENTION(TaskRequest)


#pragma mark - 我的任务接口

/**
 我的任务
 
 @param completion 回调
 */
- (void)getTaskListWithCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"task/queryTaskStatus"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 读书任务

/**
 获取推荐列表
 
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getRecommendListWithPage:(NSInteger)page
                          length:(NSInteger)length
                      completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : [NSString stringWithFormat:@"%ld", page],
                                       @"length"        : [NSString stringWithFormat:@"%ld", length],
                                       @"shareBatchId"  : @"",
                                       @"type"          : @"0", // 0 列表 1 详情
                                       @"userType"      : @"1", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectshareBook"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 获取推荐详情
 
 @param shareBatchId 推荐 id
 @param completion   回调
 */
- (void)getRecommendDetailWithShareBatchId:(NSInteger)shareBatchId
                                completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : @"0",
                                       @"length"        : @"0",
                                       @"shareBatchId"  : [NSString stringWithFormat:@"%ld", shareBatchId],
                                       @"type"          : @"1", // 0 列表 1 详情
                                       @"userType"      : @"1", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectshareBook"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 获取授权列表
 
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getImpowerListWithPage:(NSInteger)page
                        length:(NSInteger)length
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : [NSString stringWithFormat:@"%ld", page],
                                       @"length"        : [NSString stringWithFormat:@"%ld", length],
                                       @"shareBatchId"  : @"",
                                       @"type"          : @"0", // 0 列表 1 详情
                                       @"userType"      : @"1", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectGrantBooks"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 获取授权详情
 
 @param grantBatchId 推荐 id
 @param completion   回调
 */
- (void)getImpowerDetailWithGrantBatchId:(NSInteger)grantBatchId
                              completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"        : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"          : @"0",
                                       @"length"        : @"0",
                                       @"grantBatchId"  : [NSString stringWithFormat:@"%ld", grantBatchId],
                                       @"type"          : @"1", // 0 列表 1 详情
                                       @"userType"      : @"1", // 0 分享人 1 被分享人
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"organization/selectGrantBooks"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 查询任务状态

/**
 查询任务状态
 
 @param taskType   类型(1 每日 2 长期 3 一次性 0 全部)
 @param completion 回调
 */
- (void)getTaskStatusWithTaskType:(NSString *)taskType
                       completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"  : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"taskType": taskType,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"task/selectTask"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 领取任务奖励

/**
 领取任务奖励
 
 @param task        任务
 @param completion  回调
 */
- (void)getTaskAwardWithTask:(TaskModel *)task
                  completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId"       : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"taskDetailId" : [NSString stringWithFormat:@"%ld", task.taskDetailId],
                                       @"taskType"     : [NSString stringWithFormat:@"%ld", task.tasktype],
                                       @"award"        : [NSString stringWithFormat:@"%ld", task.taskreward]
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"task/receiveRewards"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

@end
