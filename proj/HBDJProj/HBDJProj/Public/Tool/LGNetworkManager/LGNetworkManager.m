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

/// 一个完整的请求包括： 1.URL,2.方法(get?post?other?),3.body参数,4.request序列化实例,5.reponse序列化实例
/// 请求头可以在request序列化实例在设置，也可以在 manager中设置

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
        _requestSerializer.timeoutInterval = 10;
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
