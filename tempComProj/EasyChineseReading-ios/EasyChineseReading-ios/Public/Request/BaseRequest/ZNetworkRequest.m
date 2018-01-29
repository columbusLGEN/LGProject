//
//  ZNetworkReuest.m
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights rese÷÷rved.
//

#import "ZNetworkRequest.h"

// 王璐42 --> 44 2018.01.03
//NSString * const AppServerBaseURL  = @"http://192.168.10.44:8080/UniversityPressService";   // 王璐服务器
//NSString * const AppServerBaseURL  = @"http://192.168.10.107:8080/UniversityPressService";  // 虚拟机
NSString * const AppServerBaseURL  = @"http://123.59.197.176:8530/UniversityPressService";  // 外网正式服务器
//NSString * const AppServerBaseURL  = @"http://202.112.197.44:8080/UniversityPressService";  // 北语服务器

//NSString * const AppHostIp = @"http://192.168.10.44:8080";
//NSString * const AppHostIp = @"http://192.168.10.107:8080";
//NSString * const AppHostIp = @"http://123.59.197.176:8530";
//NSString * const AppHostIp = @"http://202.112.197.44:8080";

NSString * const XHeaderToken          = @"token";
NSString * const XHeaderAuthorization  = @"Authorization";
NSString * const XHeaderContentType    = @"Content-Type";
NSString * const XHeaderAccept         = @"Accept";
NSString * const XHeaderAcceptLanguage = @"Accept-Language";

NSString * const XHeaderCountryCode    = @"X-Country-Code";
NSString * const XHeaderDeviceWidth    = @"X-Device-Width";
NSString * const XHeaderDeviceHeight   = @"X-Device-Height";
NSString * const XHeaderLocationlat    = @"X-Location-lat";
NSString * const XHeaderLocationlon    = @"X-Location-lng";

/**
 将 ZHttpRequestMethod 转换成 AFURLRequestSerialization 类中
 方法 - (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(ErrorModel *__autoreleasing *)error
 参数 method 用到的 string 类型参数
 */
NSString *ENUM_ZHttpRequestMethodString (ENUM_ZHttpRequestMethod method)
{
    NSString *strMethod = nil;
    switch (method) {
        case ENUM_ZHttpRequestMethodGet: {
            strMethod = @"GET";
            break;
        }
        case ENUM_ZHttpRequestMethodPost: {
            strMethod = @"POST";
            break;
        }
        case ENUM_ZHttpRequestMethodPut: {
            strMethod = @"PUT";
            break;
        }
//        case ENUM_ZHttpRequestMethodPatch: {
//            strMethod = @"PATCH";
//            break;
//        }
        case ENUM_ZHttpRequestMethodDelete: {
            strMethod = @"DELETE";
            break;
        }
    }
    return strMethod;
}

@interface ZNetworkRequest ()

- (AFHTTPSessionManager *)httpSessionManager;

@end

@implementation ZNetworkRequest

@synthesize httpSessionManager = _httpSessionManager;

+ (instancetype)shareInstance
{
    static ZNetworkRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[ZNetworkRequest alloc] init];
        [request setupConstHeaders];
    });
    
    return request;
}

/**
 * 返回 一个线程队列
 */
-(NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:100];
    }
    return _operationQueue;
}

-(instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    //        self.httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}
-(AFHTTPSessionManager *)httpSessionManager
{
    if (_httpSessionManager == nil) {
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:AppServerBaseURL] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
    _httpSessionManager.securityPolicy = securityPolicy;
    
    return _httpSessionManager;
}

- (void)setupConstHeaders
{
    [self.httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:XHeaderAccept];
    [self.httpSessionManager.requestSerializer setValue:@"zh-CN,zh" forHTTPHeaderField:XHeaderAcceptLanguage];
    [self.httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:XHeaderContentType];
}

+ (AFHTTPSessionManager*)defaultNetManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return manager;
}

- (NSString *)convertUrlStringWithString:(NSString *)urlStr andDic:(NSDictionary *)dic
{
    NSAssert(urlStr && urlStr.length, @"Are you kiding ?! The URI endpoint for requset should not be empty");
    
    NSArray * partials = [urlStr componentsSeparatedByString:@"/"];
    NSArray * targets = [partials filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] ':'"]];
    
    __block NSMutableString * path = [urlStr mutableCopy];
    [targets enumerateObjectsUsingBlock:^(NSString * str, __unused NSUInteger idx, __unused BOOL *stop) {
        NSString * param = [dic valueForKey:[str stringByReplacingOccurrencesOfString:@":" withString:@""]];
        if (param) {
            [path replaceOccurrencesOfString:str
                                  withString:[param description]
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(0, path.length)];
        }
    }];
    
    return path;
}

#pragma mark - 检查网络状态

+ (BOOL)netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL networkState = NO;
    NSURL *url = [NSURL URLWithString:strUrl];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO]; // 回复队列
                networkState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkState = NO;
            default:
                [operationQueue setSuspended:YES]; // 暂停队列
                break;
        }
        DDLog(@"networkReachabilityStatus: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    return networkState;
}

#pragma mark - 请求数据

+ (void)requestWithHttpMethod:(ENUM_ZHttpRequestMethod)method
                       strUrl:(NSString *)strUrl
                   parameters:(id)parameters
                completeBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock

{
    // 拼参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dic[@"params"]];
    NSString *uuid = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_UUID];
    if (uuid == nil || [uuid empty]) {
        [self deviceUUID];
        uuid = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_UUID];
    }
    params[@"imei"] = uuid;
    params[@"imsi"] = @"";
    params[@"userId"] = [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId > 0 ? [UserRequest sharedInstance].user.userId : 0];
    
    dic[@"params"] = params;
    dic[@"md5"] = @"654c01acaf40e0ce6d841a552fd3b96c";
    parameters = [dic mj_JSONString];
//    NSLog(@"-----parameters %@", parameters);
    // 数据加密
//    parameters = [ZAES AES128EncryptStrig:parameters];
//    NSLog(@"=====parameters %@", parameters);
    // 拼链接
    strUrl = [AppServerBaseURL stringByAppendingString:[NSString stringWithFormat:@"/%@",strUrl]];
    
    // 拼网络请求
    AFHTTPSessionManager *httpSessionManager = [ZNetworkRequest defaultNetManager];
    NSMutableURLRequest *request = [httpSessionManager.requestSerializer requestWithMethod:ENUM_ZHttpRequestMethodString(method) URLString:strUrl parameters:parameters error:nil];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:XHeaderContentType];
    [request setValue:@"application/json" forHTTPHeaderField:XHeaderAccept];
    [request setValue:[NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].language] forHTTPHeaderField:@"languageType"];
    [request setValue:[UserRequest sharedInstance].token ? [UserRequest sharedInstance].token : @"" forHTTPHeaderField:XHeaderToken];

    // 发送请求
    NSLog(@"httpHeader:%@", request.allHTTPHeaderFields);
    NSLog(@"接口地址:%@,\n 接口方法:%@,\n 接口参数:%@", strUrl, ENUM_ZHttpRequestMethodString(method), parameters);
    // 网络请求
    NSURLSessionDataTask *dataTask = [httpSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {    // 系统错误
            ErrorModel *customError = [ErrorModel new];
            customError.code = error.code;
            customError.message = error.userInfo[@"NSLocalizedDescription"];
            NSLog(@"requestError: %@", error);
            
            completeBlock(nil, customError);
        }
        else {
            if (responseObject == nil) { // 防止数据丢失崩溃
                ErrorModel *customError = [ErrorModel new];
                customError.code = 1;
                customError.message = LOCALIZATION(@"网络连接失败");
                completeBlock(nil, customError);
            }
            responseObject = [responseObject mj_JSONObject];
            NSInteger resultCode = [[responseObject objectForKey:@"result"] integerValue];
            NSString *msg = [responseObject objectForKey:@"msg"];
            NSString *en_msg = [responseObject objectForKey:@"en_msg"];
            NSString *errorMessage = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? msg : en_msg;
            if (resultCode == 0) {
                NSLog(@"requestObject: %@", [responseObject objectForKey:@"returnJson"]);
                NSString *returnJson = [responseObject objectForKey:@"returnJson"];
                    // 数据解密
//                NSString *blockJson = [ZAES AES128DecryptString:returnJson];
//                completeBlock(blockJson, nil);
                completeBlock(returnJson, nil);
            }
            else if (resultCode == 3) { // token 不对被踢掉（其他设备登录）
                if ([[UserRequest sharedInstance] online]) {
                    [[UserRequest sharedInstance] kickoutWithMessage:errorMessage];
                }
                else {
                    NSLog(@"=================被踢掉出错啦！！！！==============");
                }
                completeBlock(nil, nil);
            }
            else {   // 错误
                ErrorModel *customError = [ErrorModel new];
                customError.code = [[responseObject objectForKey:@"result"] integerValue];
                customError.message = errorMessage;
                NSLog(@"customError: %@", customError);
                
                completeBlock([responseObject objectForKey:@"returnJson"], customError);
            }
        }
    }];
    [dataTask resume];
}

#pragma mark - 下载文件
/**
 * 下载 文件 照片 语音 等
 * 传 地址
 */
+ (void)downLoadFileWithUrlString:(NSString *)urlString
                         progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                  completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock
{
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //创建会话管理对象（在不使用Configuration来设置时用默认的manager足矣）
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    /**
     创建下载任务
    
     第一个参数:请求对象
     第二个参数:progress 进度回调
     第三个参数:destination 回调(目标位置)
     有返回值
     targetPath:临时文件路径
     response:响应头信息
     第四个参数:completionHandler 下载完成后的回调
     filePath:最终的文件路径
     */
    
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        progress(downloadProgress.completedUnitCount * 1.0, downloadProgress.totalUnitCount * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //接收到响应，准备开始接受数据
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        //打印请求状态码
        NSLog(@"状态码:%li", httpResponse.statusCode);
        
        //targetPath临时问价保存路径
        
        //返回值为本次下载任务的保存路径
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        //保存的文件路径
//        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        //此block返回值为下载完之后文件存放的路径
        //这个返回的NSURL后面会传到filePath，因此这里自己设置的filePath可以随意取名
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //这个block返回的filePath实际上就是我们上面给他的确定的filePath,在这里他提供了这个可查下载文件路径的参数
        NSLog(@"下载完成路径:%@", filePath);
    }];
    
    //开始任务
    [downloadTask resume];
}

#pragma mark - 上传文件

/**
 * 上传 文件 照片 语音 等  最新接口
 * 传 上传类型、 地址、 数据
 */

+ (void)upLoadFileWithUrlString:(NSString *)urlString
                          files:(NSArray *)files
                       progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock
{
    //创建manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];

    /**
     创建上传任务
     
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject响应体信息
     第六个参数:失败回调
     */
    [sessionManager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:date];
        NSString *filename = [NSString stringWithFormat:@"%@%ld", dateString, [UserRequest sharedInstance].user.userId];
//        for (NSInteger i = 0; i < files.count; i ++) {
            [formData appendPartWithFileData:files.firstObject name:filename fileName:[NSString stringWithFormat:@"%@.jpeg", filename] mimeType:@"image/jpeg"];
//        }
    } progress: ^(NSProgress * uploadProgress){
        NSLog(@"%@", uploadProgress);
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败:%@",error);
    }];
}

/**
 上传data文件
 */

+ (void)upLoadFileWithUrlString:(NSString *)urlString
                           data:(NSData *)data
                       progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock
{
    //上传
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", AppServerBaseURL, @"user/uploadPictures"]]];
    
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name = \"pic\"; filename=\"%@\"\r\n", urlString] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    
    NSString *string = [NSString stringWithFormat:@"%@; %@", @"multipart/form-data", @"boundary=----------V2ymHFg03ehbqgZCaKO6jy"];
    [request setValue:string forHTTPHeaderField:XHeaderContentType];

    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:20];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:body progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    //重新开始上传
    [uploadTask resume];
}

/**
 * 上传 文件 照片 语音 等
 * 传 上传类型、 地址、 数据
 */

+ (void)upLoadFileWithUrlString:(NSString *)urlString
                           file:(NSURL *)file
                       progress:(void (^)(long long completedUnitCount, long long totalUnitCount))progress
                completionBlock:(void (^)(id responseObject, ErrorModel *error))completeBlock
{
    //上传
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request
                                                               fromFile:filePath
                                                               progress:^(NSProgress * uploadProgress){
                                                                   NSLog(@"%@", uploadProgress);
                                                               }
                                                      completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                          if (error) {
                                                              NSLog(@"Error: %@", error);
                                                          } else {
                                                              NSLog(@"Success: %@ %@", response, responseObject);
                                                          }
                                                      }];
    //重新开始上传
    [uploadTask resume];
}

/** 上传图片 */
+ (void)uploadImg:(NSData *)imageData urlString:(NSString *)urlString parameters:(NSDictionary *)parameters callBack:(CompleteBlock)callBack {
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc] initWithFormat:@"--%@", TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc] initWithFormat:@"%@--", MPboundary];
    // 压缩图片
//    NSData *imageData = nil;
//    CGFloat compression = 1.0;
//    do {
//        imageData = UIImageJPEGRepresentation(image, compression);
//        compression -= 0.1;
//    } while (imageData.length / 1024.0 > 300);
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc] init];
    //参数的集合的所有key的集合
    for (NSString *key in [parameters allKeys]) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
    }
    // 添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    
    // 图片名
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *filename = [NSString stringWithFormat:@"%@%ld", dateString, [UserRequest sharedInstance].user.userId];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@.jpeg\"\r\n", filename];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n"];
    [body appendFormat:@"userId: %ld\r\n\r\n", [UserRequest sharedInstance].user.userId];
    //声明结束符：--AaB03x--
    NSString *end = [[NSString alloc] initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:imageData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content = [[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               dispatch_sync(dispatch_get_main_queue(), ^{
                                   if (connectionError) {    // 系统错误
                                       ErrorModel *customError = [ErrorModel new];
                                       customError.code = connectionError.code;
                                       customError.message = connectionError.userInfo[@"NSLocalizedDescription"];
                                       NSLog(@"requestError: %@", connectionError);
                                       
                                       callBack(nil, customError);
                                   }
                                   else {
                                       NSDictionary *responseObject = [data mj_JSONObject];
//                                       id obj = [data JSONData];
//                                       id obj1 = [data JSONString];
                                       if ([[responseObject objectForKey:@"result"] integerValue] != 0) {   // 如果 return 不为0则是错误
                                           ErrorModel *customError = [ErrorModel new];
                                           customError.code = [[responseObject objectForKey:@"result"] integerValue];
                                           customError.message = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? [responseObject objectForKey:@"msg"] : [responseObject objectForKey:@"en_msg"];
                                           NSLog(@"customError: %@", customError);
                                           
                                           callBack([responseObject objectForKey:@"returnJson"], customError);
                                       }
                                       else {
                                           NSLog(@"requestObject: %@", [responseObject objectForKey:@"returnJson"]);
                                           callBack([responseObject objectForKey:@"returnJson"], nil);
                                       }
                                   }
                               });
                           }];
}

@end
