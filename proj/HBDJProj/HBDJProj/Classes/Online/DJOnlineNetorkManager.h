//
//  DJOnlineNetorkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJOnlineNetorkManager : NSObject

/** 获取三会一课列表数据 */
- (void)frontSessionsWithSessiontype:(NSInteger)sessionType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 获取主题党日列表数据 */
- (void)frontThemesWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

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

- (void)onlineHomeConfigSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

CM_SINGLETON_INTERFACE
@end
