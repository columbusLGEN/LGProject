//
//  DJOnlineNetorkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJOnlineNetorkManager : NSObject

/**
 在线模块搜索接口
 type:
 1 搜索三会一课主题当日党建述职思想汇报 (党建工作台账)
 2 在线投票
 3 在现测试 */
- (void)frontIndex_onlineSearchWithContent:(NSString *)content type:(NSInteger)type offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 请求测试成绩排行榜 */
- (void)frontSubjects_selectTestRankWithTestid:(NSInteger)testid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/**
 提交答案

 @param jsonDict 答题情况json字典
 */
- (void)frontSubjects_addTestWithPJSONDict:(NSDictionary *)jsonDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 回看试题 */
- (void)frontSubjects_selectTestsPlayBackWithTestid:(NSInteger)testid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 题目接口

 portName:
 Title -- 题库
 Tests -- 测试题库
 */
- (void)frontSubjects_selectTitleDetailWithPortName:(NSString *)portName titleid:(NSInteger)titleid offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 题库和测试题库列表请求
 portName:
 Title -- 题库
 Tests -- 测试题库
 */
- (void)frontSubjects_selectWithPortName:(NSString *)portName offset:(NSInteger)offset success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 提交投票结果接口

 @param voteid 投票的主题id
 @param votedetailid 选项id
 @param success 成功回调
 @param failure 失败回调
 */
- (void)frontVotes_addWithVoteid:(NSInteger)voteid votedetailid:(NSArray *)votedetailid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 投票详情,标题，选项等 */
- (void)frontVotes_selectDetailWithVoteid:(NSInteger)voteid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 在线投票列表 */
- (void)frontVotes_selectWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 获取党员舞台、思想汇报、党建述职 列表数据

 @param ugcType 类型：1党员舞台 2思想汇报 3党建述职
 */
- (void)frontUgcWithType:(DJOnlineUGCType)ugcType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 获取三会一课列表数据 */
- (void)frontSessionsWithSessiontype:(NSInteger)sessionType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 获取主题党日列表数据 */
- (void)frontThemesWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/**
 上传思想汇报，党建述职，党员舞台

 @param formDict json字典
 @param ugctype 1党员舞台; 2思想汇报; 3党建述职
 @param filetype 1图片; 2视频; 3音频; 4文本
 @param success 成功回调
 @param failure 失败回调
 */
- (void)frontUgc_addWithFormData:(NSMutableDictionary *)formDict ugctype:(NSInteger)ugctype filetype:(NSInteger)filetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 上传三会一课 */
- (void)addSessionsWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
上传主题党日

 @param formDict 封装好的表单数据
 @param success 成功
 @param failure 失败
 */
- (void)addThemeWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 机构人员列表 */
- (void)frontUserinfoSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 上传图片 */
- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure;
/** 上传文件 */
- (void)uploadFileWithLocalFileUrl:(NSURL *)localFileUrl mimeType:(NSString *)mimeType uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadFileSuccess)success failure:(LGUploadImageFailure)failure;

- (void)onlineHomeConfigSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

CM_SINGLETON_INTERFACE
@end
