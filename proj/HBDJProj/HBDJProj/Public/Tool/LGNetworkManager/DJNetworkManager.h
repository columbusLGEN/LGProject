//
//  DJNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// MARK: 党建项目专用请求管理者

#import <Foundation/Foundation.h>

typedef void(^DJNetworkSuccess)(id responseObj);
/** 请求失败时，返回包有 msg 和 result的字典，网络连接失败时，返回 “网络异常” 的 字符串 */
typedef void(^DJNetworkFailure)(id failureObj);
//typedef void(^DJNetworkShowErrorCallBack)(id responseObj,NSString *msg);

@interface DJNetworkManager : NSObject

/**
 发送POST请求并返回task实例

 @param iName 接口名
 @param param 参数
 @param needUserid 是否需要用户id，传NO表示不需要
 @param success 成功
 @param failure 失败
 @return task实例
 */
- (NSURLSessionTask *)taskForPOSTRequestWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/**
 MARK: 上传表单数据的统一方法
 @param iName 接口名
 @param param 参数
 @param needUserid 是否需要用户id，传NO表示不需要
 @param success 成功回调
 @param failure 失败回调
 */
- (void)sendTableWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/// MARK: 分页接口统一调用此方法
- (void)commenPOSTWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort iName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

+ (instancetype)sharedInstance;
@end
