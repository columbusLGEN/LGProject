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

@end

@implementation LGNetworkAgent

- (NSURLSessionDataTask *)POSTWithRequest:(LGBaseRequest *)request{
    NSString *interface;
    if (request.packageName) {
        interface = [NSString stringWithFormat:@"%@%@",request.packageName,request.requestUrl];
    }else{
        interface = request.requestUrl;
    }
    NSURL *baserUrl = [NSURL URLWithString:self.baseUrl];
    NSString *url = [NSURL URLWithString:interface relativeToURL:baserUrl].absoluteString;
    
    return [self.manager POST:url parameters:request.requestArguments progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (request.requestSuccess) request.requestSuccess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (request.networkFailure) request.networkFailure(error);
    }];
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
        _manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传普通格式
        
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
        /// 返回格式为 JSON
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        /// 设置请求头
        [_manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"languageType"];
        [_manager.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
        
        /// 超时时间
        //    _manager.requestSerializer.timeoutInterval = 10.f;
    }
    return _manager;
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
        self.baseUrl = @"http://202.112.197.44:8080";
        
    }
    return self;
}

//- (void)addRequest:(LGBaseRequest *)request {
//
//    /// 该方法中还可以添加请求缓存，自定义请求判断等操作
//
//    request.requestTask = [self sesstionTaskForRequest:request];
//
//    [request.requestTask resume];
//}
//
//- (NSURLSessionTask *)sesstionTaskForRequest:(LGBaseRequest *)request{
//    LGRequestMethod method = request.requestMethod;
//
//    switch (method) {
//        case LGRequestMethodPOST:
//            return nil;
//            break;
//        case LGRequestMethodGET:
//            return [self POSTWithRequest:request];
//            break;
//    }
////    return nil;
//}

@end
