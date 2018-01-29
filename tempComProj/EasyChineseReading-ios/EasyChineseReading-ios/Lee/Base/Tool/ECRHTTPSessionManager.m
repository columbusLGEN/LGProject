//
//  ECRHTTPSessionManager.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRHTTPSessionManager.h"

//#import "DES3Util.h"// des加密类
#import "NSString+TOPExtension.h"
#import "ErrorModel.h"

static CGFloat timeOutLimit = 10.0;

@interface ECRHTTPSessionManager ()
@property (strong,nonatomic) AFHTTPSessionManager *afnSessionManager;//

/** URLSessionManager */
@property (strong,nonatomic) AFURLSessionManager *URLSessionManager;
///** URLSessionManager configuration */
@property (strong,nonatomic) NSURLSessionConfiguration *configuration;

@end

@implementation ECRHTTPSessionManager

// 1016
- (void)POSTWithInterface:(NSString *)interface param:(id)param success:(ECRLEHTTPSuccess)success failure:(ECRLEHTTPFailure)failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",AppServerBaseURL,interface];

    // 直接使用afn的请求配置方法
    __block NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:param error:nil];
    
    // 设置请求头x
    // 1.中英文
    [request setValue:[NSString
                       stringWithFormat:@"%d",
                       [self currentLanguageTypeIsEn]]
   forHTTPHeaderField:@"languageType"];
    
    // 2.token
    [request setValue:[self localToken] forHTTPHeaderField:@"token"];

    NSURLSessionDataTask *dataTask = [self.URLSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        // 清空headerfields,否则内存泄漏
        [request setAllHTTPHeaderFields:nil];
        request = nil;
        
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(responseObject);
            }
        }
    }];
    [dataTask resume];

}

- (AFURLSessionManager *)URLSessionManager{
    if (_URLSessionManager == nil) {
        _URLSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:self.configuration];
    }
    return _URLSessionManager;
}

- (NSURLSessionConfiguration *)configuration{
    if (_configuration == nil) {

        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _configuration.timeoutIntervalForRequest = timeOutLimit;
    }
    return _configuration;
}

- (BOOL)currentLanguageTypeIsEn{
    //    0：汉语
    //    1：英语
    return [LGPChangeLanguage currentLanguageIsEnglish];
}
- (NSString *)localToken{
    return [UserRequest sharedInstance].token ? [UserRequest sharedInstance].token : @"";
}

NSString *methodName(ECRHTTPRequestMethod method){
    NSString *mName;
    switch (method) {
        case 0:
            mName = @"GET";
            break;
        case 1:
            mName = @"POST";
            break;
            
    }
    return mName;
}

+ (instancetype)sharedManager{
    static ECRHTTPSessionManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ECRHTTPSessionManager alloc] init];
    });
    return instance;
}

// ****************************************************************
- (AFHTTPSessionManager *)afnSessionManager{
    if (_afnSessionManager == nil) {
        _afnSessionManager = [AFHTTPSessionManager manager];
        _afnSessionManager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
        // MARK: 设置反序列化格式
        _afnSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"charset=utf-8", nil];
        _afnSessionManager.requestSerializer.timeoutInterval = timeOutLimit;
        
        // 设置请求头
        //        [_afnSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
    }
    return _afnSessionManager;
}

@end
