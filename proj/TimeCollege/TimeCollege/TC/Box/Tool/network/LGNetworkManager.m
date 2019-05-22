//
//  LGNetworkManager.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGNetworkManager.h"
#import "LGRequestModel.h"
#import "AFNetworking.h"

@interface LGNetworkManager ()
@property (strong,nonatomic) AFHTTPSessionManager *manager;

@end

@implementation LGNetworkManager{
    BOOL _debug;
}

/** GET */
- (void)GETWithUrl:(NSString *)url
         parameters:(id)parameters
            success:(LGRequestSuccess)success
            failure:(LGRequestFailure)failure{
    [self sendRequest:url method:LGRequestMethodGET parameters:parameters success:success failure:failure];
}
/** POST */
- (void)POSTWithUrl:(NSString *)url
         parameters:(id)parameters
            success:(LGRequestSuccess)success
            failure:(LGRequestFailure)failure{
    [self sendRequest:url method:LGRequestMethodPOST parameters:parameters success:success failure:failure];
}
/** DELETE */

#pragma mark - ========== 私有方法 (private method) ==========
/** 配置请求信息,发起请求 */
- (void)sendRequest:(NSString *)url
              method:(LGRequestMethod)method
          parameters:(id)parameters
             success:(LGRequestSuccess)success
             failure:(LGRequestFailure)failure{
    
    LGRequestModel *requestModel = [LGRequestModel.alloc init];
    
    requestModel.method = [self methodStringFromRequestMethod:method];
    requestModel.url = url;
//    requestModel.url = [hostURL stringByAppendingFormat:@"/%@",url];
    requestModel.param = parameters;
    requestModel.portName = url;
    requestModel.successBolck = success;
    requestModel.failureBlock = failure;
    
    NSError *error;
    
    NSURLSessionDataTask *task = [self lg_dataTaskWithRequestModel:requestModel requestSerializer:self.manager.requestSerializer error:&error];
    
    requestModel.task = task;
    
    [task resume];
}
/** 返回 SessionDataTask */
- (NSURLSessionDataTask *)lg_dataTaskWithRequestModel:(LGRequestModel *)requestModel
                                    requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                                error:(NSError * _Nullable __autoreleasing *)error{
    
//    __weak typeof(self) weakSelf = self;
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestModel.method
                                                              URLString:requestModel.url
                                                             parameters:requestModel.param
                                                                  error:error];
    
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request
                                                    uploadProgress:nil
                                                  downloadProgress:nil
                                                 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                     
                                                     [self handleRequestModel:requestModel responseObject:responseObject error:error];
                                                     
    }];
    
    
    return task;
}

- (void)handleRequestModel:(LGRequestModel *)requestModel responseObject:(id)responseObject error:(NSError *)error{
    
    BOOL success = YES;
    
    if (error) {
        success = NO;
    }
    
    if (success) {
        requestModel.responseObject = responseObject;
        [self requestDidSuccessWithRequestModel:requestModel];
    }else{
        [self requestDidFailedWithRequestModel:requestModel error:error];
        
    }
    
}

- (void)requestDidSuccessWithRequestModel:(LGRequestModel *)requestModel{
    /// todo: 如果之后添加 缓存功能,则在此将 数据写入本地缓存
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_debug) {
            NSLog(@" ===== %@_success ===== \nparam: %@\nresponseObject: %@",
                  requestModel.param,
                  requestModel.portName,requestModel.responseObject);
        }
        if (requestModel.successBolck) {
            requestModel.successBolck(requestModel);
        }
    });
}

- (void)requestDidFailedWithRequestModel:(LGRequestModel *)requestModel error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self -> _debug) {
            NSLog(@"===== %@_error ===== \n%zd \n%@",requestModel.portName,error.code,error);
        }
        
        if (requestModel.failureBlock){
            requestModel.failureBlock(error, error.code, requestModel.task);
        }
        
    });
}

- (NSString *)methodStringFromRequestMethod:(LGRequestMethod)method{
    
    switch (method) {
            
        case LGRequestMethodGET:{
            return @"GET";
        }
            break;
            
        case LGRequestMethodPOST:{
            return  @"POST";
        }
            break;
            
        case LGRequestMethodPUT:{
            return  @"PUT";
        }
            break;
            
        case LGRequestMethodDELETE:{
            return  @"DELETE";
        }
            break;
    }
}

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
        /// 设置请求头,只执行一次
//        [_manager.requestSerializer setValue:kLGUUID forHTTPHeaderField:@"deviceId"];
    }
    /// 设置请求头,多次执行,用于值可变时设置
//    [_manager.requestSerializer setValue:[self authorizationString] forHTTPHeaderField:k_Authorization];
    return _manager;
}

#pragma mark - init

- (instancetype)init{
    if (self = [super init]) {
        _debug = YES;
        
    }
    return self;
}

+ (instancetype)sharedNetworkManager{
    static LGNetworkManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [LGNetworkManager.alloc init];
    });
    return instance;
}
@end
