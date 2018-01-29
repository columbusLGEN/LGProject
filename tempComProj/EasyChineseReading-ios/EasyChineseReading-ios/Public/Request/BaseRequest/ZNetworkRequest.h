//
//  ZNetworkReuest.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const AppServerBaseURL; // 网络请求基本地址

typedef void(^CompleteBlock)(id object,ErrorModel * error);

@interface ZNetworkRequest : NSObject {
    AFHTTPSessionManager * _httpSessionManager;
}

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;
@property (strong, nonatomic) NSOperationQueue *operationQueue;//队列

+ (instancetype)shareInstance;
+ (AFHTTPSessionManager *)defaultNetManager;

#pragma mark - 检查网络状态

+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma mark - 请求数据

/**
 *  @brief 请求网络数据
 *
 *  @param method         调用请求方法
 *  @param strUrl         地址字符串
 *  @param parameters     参数
 *  @param completeBlock  返回结果
 */
+ (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                       strUrl:(NSString *)strUrl
                   parameters:(id)parameters
                completeBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock;

/**
 * 下载 文件 照片 语音 等
 * 传 地址 */
+ (void)downLoadFileWithUrlString:(NSString *)urlString
                         progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                  completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock;


/**
 * 上传 文件 照片 语音 等  最新接口
 * 传 上传类型、 地址、 数据
 */

+ (void)upLoadFileWithUrlString:(NSString *)urlString
                          files:(NSArray *)files
                       progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock;

/**
 上传data文件
 */

+ (void)upLoadFileWithUrlString:(NSString *)urlString
                           data:(NSData *)data
                       progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock;

/**
 上传path文件
 */

+ (void)upLoadFileWithUrlString:(NSString *)urlString
                           file:(NSURL *)file
                       progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock;
/** 上传图片 */
+ (void)uploadImg:(NSData *)imageData urlString:(NSString *)urlString parameters:(NSDictionary *)parameters callBack:(CompleteBlock)callBack;

@end
