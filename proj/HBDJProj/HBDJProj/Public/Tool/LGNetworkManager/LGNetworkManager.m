//
//  LGNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGNetworkManager.h"

@interface LGNetworkManager ()
@property (strong,nonatomic) AFHTTPSessionManager *manager;

@property (strong,nonatomic) AFHTTPRequestSerializer *requestSerializer;
@property (strong,nonatomic) AFJSONResponseSerializer *jsonResponseSerializer;

@end

@implementation LGNetworkManager

- (void)lg_uploadFileWithUrl:(NSString *)url param:(NSDictionary *)param localFileUrl:(NSURL *)localFileUrl fieldName:(NSString *)fieldName fileName:(NSString *)fileName mimeType:(NSString *)mimeType uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadFileSuccess)success failure:(LGUploadImageFailure)failure{
    
    /// name 为 接口接受图片的字段名
    /// fileName 为 保存到服务器上的文件名
    /// fieldName 为 接口接受文件的字段名
    
    NSMutableDictionary *argu = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:argu constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error;
        [formData appendPartWithFileURL:localFileUrl name:fieldName fileName:fileName mimeType:mimeType error:&error];
        if (error) {
            NSLog(@"appendDataError.debugDescription: %@",error.debugDescription);
        }
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self.manager uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) failure(@"请检查网络");
        }else{
            NSNumber *result = [responseObject objectForKey:@"result"];
            NSString *returnJson = [responseObject objectForKey:@"returnJson"];
            NSData *data = [returnJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"上传文件回调: %@",responseObject);
            if (result.intValue == 0) {/// 成功
                if (success) success(dict);
            }else{
                if (failure) failure(@"上传失败的msg");
            }
        }
    }];
    [uploadTask resume];
    
}

- (void)uploadImageWithUrl:(NSString *)url param:(NSDictionary *)param localFileUrl:(NSURL *)localFileUrl fieldName:(NSString *)fieldName fileName:(NSString *)fileName uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    
    [self lg_uploadFileWithUrl:url param:param localFileUrl:localFileUrl fieldName:fieldName fileName:fileName mimeType:@"image/jpeg" uploadProgress:progress success:^(id dict) {
        if (success) success(dict);
    } failure:failure];
    
}

- (void)checkNetworkStatusWithBlock:(void(^)(AFNetworkReachabilityStatus status))netsBlock{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        
//        AFNetworkReachabilityStatusUnknown          = -1,/// 未识别的网络
//        AFNetworkReachabilityStatusNotReachable     = 0,/// 不可达的网络，未连接
//        AFNetworkReachabilityStatusReachableViaWWAN = 1,/// 2G，3G，4G
//        AFNetworkReachabilityStatusReachableViaWiFi = 2,/// wifi
        
        if (netsBlock) netsBlock(status);
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

/**
 发送post请求，同时返回 task 实例

 @param url 请求链接
 @param param 参数字典
 @param completionHandler 完成回调
 @return task 实例
 */
- (NSURLSessionTask *)taskForPOSTRequestWithUrl:(NSString *)url param:(id)param completionHandler:(nullable LGNetworkCompletion)completionHandler{
    NSError *error;
    NSURLSessionDataTask *task = [self dataTaskWithHTTPMethod:@"POST" requestSerializer:self.requestSerializer URLString:url param:param error:error completionHandler:completionHandler];
    [task resume];
    return task;
}

/**
 发送post请求,不返回 task实例

 @param url 请求链接
 @param param 参数字典
 @param completionHandler 完成回调
 */
- (void)sendPOSTRequestWithUrl:(NSString *)url param:(id)param completionHandler:(nullable LGNetworkCompletion)completionHandler{
    NSError *error;
    NSURLSessionDataTask *task = [self dataTaskWithHTTPMethod:@"POST" requestSerializer:self.requestSerializer URLString:url param:param error:error completionHandler:completionHandler];
    [task resume];
}
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method requestSerializer:(AFHTTPRequestSerializer *)requestSerializer URLString:(NSString *)URLString param:(id)param error:(NSError *)error completionHandler:(nullable LGNetworkCompletion)completionHandler{
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:param error:&error];
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:completionHandler];
    return dataTask;
}

- (AFHTTPRequestSerializer *)requestSerializer{
    if (!_requestSerializer) {
        _requestSerializer = [AFJSONRequestSerializer serializer];
        /// 超时时间
        _requestSerializer.timeoutInterval = 11;
        /// 是否允许蜂窝数据
        _requestSerializer.allowsCellularAccess = YES;
        
        /// 如果api 需要 用户名和密码
        //    _requestSerializer setAuthorizationHeaderFieldWithUsername:<#(nonnull NSString *)#> password:<#(nonnull NSString *)#>
        /// MARK: 这里可以修改请求头
        //    _requestSerializer setValue:<#(nullable NSString *)#> forHTTPHeaderField:<#(nonnull NSString *)#>
        
    }
    return _requestSerializer;
}
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
        /// 最大请求并发任务数
        _manager.operationQueue.maxConcurrentOperationCount = 10;
        
        // 请求格式
        // AFHTTPRequestSerializer            二进制格式
        // AFJSONRequestSerializer            JSON
        // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [_manager.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        
        /// 接受的content-type
        _manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain", nil];
        
        // 返回格式
        // AFHTTPResponseSerializer           二进制格式
        // AFJSONResponseSerializer           JSON
        // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
        // AFXMLDocumentResponseSerializer (Mac OS X)
        // AFPropertyListResponseSerializer   PList
        // AFImageResponseSerializer          Image
        // AFCompoundResponseSerializer       组合
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        /// MARK: 这里也可以修改请求头
//        [_manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"languageType"];
//        [_manager.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
        
        /// 超时时间
        //    _manager.requestSerializer.timeoutInterval = 10.f;
    }
    return _manager;
}
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
