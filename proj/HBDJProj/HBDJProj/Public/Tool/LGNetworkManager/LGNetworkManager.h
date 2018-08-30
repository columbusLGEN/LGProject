//
//  LGNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// MARK: 通用的请求管理者，可以复用

#import <Foundation/Foundation.h>

typedef void (^LGUploadImageProgressBlock)(NSProgress *uploadProgress);
typedef void (^LGUploadImageSuccess)(id dict);
typedef void (^LGUploadImageFailure)(id uploadFailure);

typedef void (^LGUploadFileSuccess)(id dict);

typedef void(^LGNetworkCompletion)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error);

@interface LGNetworkManager : NSObject


/**
 上传文件

 @param url 接口连接
 @param param 参数
 @param localFileUrl 本地文件路径
 @param fieldName 接口接受文件的字段名
 @param fileName 文件名(存到服务器上的)
 @param mimeType 文件类型
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
- (void)lg_uploadFileWithUrl:(NSString *)url param:(NSDictionary *)param localFileUrl:(NSURL *)localFileUrl fieldName:(NSString *)fieldName fileName:(NSString *)fileName mimeType:(NSString *)mimeType uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadFileSuccess)success failure:(LGUploadImageFailure)failure;

/**
 上传图片
 
 @param url 接口链接
 @param param 参数
 @param localFileUrl 本地文件路径
 @param fieldName 接口接受文件的字段名
 @param fileName 文件名(存到服务器上的)
 @param progress 上传进度
 */
- (void)uploadImageWithUrl:(NSString *)url param:(NSDictionary *)param localFileUrl:(NSURL *)localFileUrl fieldName:(NSString *)fieldName fileName:(NSString *)fileName uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure;

- (NSURLSessionTask *)taskForPOSTRequestWithUrl:(NSString *)url param:(id)param completionHandler:(nullable LGNetworkCompletion)completionHandler;

- (void)sendPOSTRequestWithUrl:(NSString *)url param:(id)param completionHandler:(LGNetworkCompletion)completionHandler;

/**
 检查网络状态

 @param netsBlock 回调网络状态
 */
- (void)checkNetworkStatusWithBlock:(void(^)(AFNetworkReachabilityStatus status))netsBlock;

+ (instancetype)sharedInstance;
@end
