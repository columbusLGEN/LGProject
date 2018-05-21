//
//  LGNetworkAgent.m
//  LGNetworking
//
//  Created by Peanut Lee on 2018/5/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGNetworkAgent.h"
#import "AFNetworking.h"
#import "LGBaseRequest.h"

@interface LGNetworkAgent ()
@property (strong,nonatomic) AFHTTPSessionManager *manager;
@property (strong,nonatomic) NSString *baseUrl;
@property (strong,nonatomic) AFJSONResponseSerializer *jsonResponseSerializer;

@end

@implementation LGNetworkAgent

- (void)addRequest:(LGBaseRequest *)request {

    NSError *error;
    /// 该方法中还可以添加请求缓存，自定义请求判断等操作

    request.requestTask = [self sessionTaskForRequest:request error:error];

    [request.requestTask resume];
}

- (NSURLSessionTask *)sessionTaskForRequest:(LGBaseRequest *)request error:(NSError *)error{
    LGRequestMethod method = request.requestMethod;
    NSString *URLString = [self buildRequestUrl:request];
    id param = request.requestArguments;
    AFHTTPRequestSerializer *serializer = [self requestSerializerForRequest:request];

    switch (method) {
        case LGRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:serializer URLString:URLString param:param error:error];
            break;
        case LGRequestMethodGET:
            return nil;
            break;
    }
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method requestSerializer:(AFHTTPRequestSerializer *)requestSerializer URLString:(NSString *)URLString param:(id)param error:(NSError *)error{
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:param error:&error];
    
    NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    
    return dataTask;
}

- (void)handleRequestResult:(NSURLSessionTask *)dataTask responseObject:(id)responseObject error:(NSError *)error{
    /// TODO: 如何统一处理返回值，分发数据？
    NSLog(@"responseObject -- %@",responseObject);
    NSLog(@"error -- %@",error);
//    id jsonObject = [self.jsonResponseSerializer responseObjectForResponse:dataTask.response data:responseObject error:&error];
//    NSLog(@"jsonobject -- %@",jsonObject);
    
    //        NSError *serializerError;
    //        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    //        id object = [serializer responseObjectForResponse:task.response data:responseObject error:&serializerError];
    //        if (serializerError) {
    //            NSLog(@"error -- %@",serializerError);
    //        }else{
    //            NSLog(@"解析后 -- %@ CLASS: %@",object,[object class]);
    //        }
    
    //        if (request.networkFailure) request.networkFailure(error);
    
}

- (NSString *)buildRequestUrl:(LGBaseRequest *)request{
    NSString *interface;
    if (request.packageName) {
        interface = [NSString stringWithFormat:@"%@%@",request.packageName,request.requestUrl];
    }else{
        interface = request.requestUrl;
    }
    NSURL *baserUrl = [NSURL URLWithString:self.baseUrl];
    NSString *url = [NSURL URLWithString:interface relativeToURL:baserUrl].absoluteString;
    return url;
}
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(LGBaseRequest *)request{
    AFHTTPRequestSerializer *serializer = nil;
    if (request.requestSerializerType == LGRequestSerializerTypeHTTP) {
        serializer = [AFHTTPRequestSerializer serializer];
    }else{
        serializer = [AFJSONRequestSerializer serializer];
    }
    
    serializer.timeoutInterval = 10;///[request requestTimeoutInterval];
    /// 是否允许蜂窝数据
    serializer.allowsCellularAccess = YES;/// [request allowsCellularAccess];
    
    /// MARK 如果api 需要 用户名和密码
    //    serializer setAuthorizationHeaderFieldWithUsername:<#(nonnull NSString *)#> password:<#(nonnull NSString *)#>
    
    /// MARK: 如果api 需要向 请求头 添加键值
    //    serializer setValue:<#(nullable NSString *)#> forHTTPHeaderField:<#(nonnull NSString *)#>
    return serializer;
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
        
        /// 设置请求头
        [_manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"languageType"];
        [_manager.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
        
        /// 超时时间
        //    _manager.requestSerializer.timeoutInterval = 10.f;
    }
    return _manager;
}
- (AFJSONResponseSerializer *)jsonResponseSerializer{
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
//        self.baseUrl = @"http://202.112.197.44:8080";
        self.baseUrl = @"http://192.168.10.110:8080";
    }
    return self;
}

@end
