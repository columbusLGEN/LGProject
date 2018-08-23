//
//  DJDiscoveryNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/15.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJDiscoveryNetworkManager : NSObject


/**
 发现搜索

 @param content 搜索内容
 @param labelid 搜索标签id
 @param offset 偏移
 @param type 类型 0所有,1学习问答,2支部动态,3党员舞台
 @param success
 @param failure
 */
- (void)frontIndex_findSearchWithContent:(NSString *)content label:(NSInteger)labelid offset:(NSInteger)offset type:(NSInteger)type success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 提交提问 */
- (void)frontQuestionanswer_addWithQuestion:(NSString *)question label:(NSString *)label success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 请求标签,上传提问时用 */
- (void)frontLabel_selectWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 发表评论

 @param commentid 对应的党员舞台或支部动态id
 @param commenttype 评论类型：1党员舞台,2支部动态
 @param comment 评论内容
 */
- (void)frontComments_addWithCommentid:(NSInteger)commentid commenttype:(NSInteger)commenttype comment:(NSString *)comment success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 党员舞台列表 */
- (void)frontUgc_selectmechanismWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 查看支部动态列表 */
- (void)frontBranch_selectWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 查看支部的提问列表接口 */
- (void)frontQuestionanswer_selectmechanismWithOffset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 发现首页接口 */
- (void)frontIndex_findIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

CM_SINGLETON_INTERFACE
@end
