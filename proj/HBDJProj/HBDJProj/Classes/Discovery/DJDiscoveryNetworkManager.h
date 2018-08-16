//
//  DJDiscoveryNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/15.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJDiscoveryNetworkManager : NSObject

/** 提问感谢接口 */
- (void)frontQuestionanswer_updateWithQAId:(NSInteger)qaid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/// -------
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
