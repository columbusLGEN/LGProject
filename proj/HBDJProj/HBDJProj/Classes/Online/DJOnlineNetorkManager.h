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
上传主题党日

 @param formDict 封装好的表单数据
 @param success 成功
 @param failure 失败
 */
- (void)addThemeWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 上传图片 */
- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure;

- (void)onlineHomeConfigSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

CM_SINGLETON_INTERFACE
@end
