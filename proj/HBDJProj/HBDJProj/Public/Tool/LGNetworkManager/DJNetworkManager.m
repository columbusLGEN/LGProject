//
//  DJNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJNetworkManager.h"
#import "LGNetworkManager.h"
#import "LGNetworkCache.h"

static NSString *param_key_userid = @"userid";

@interface DJNetworkManager ()
@property (strong,nonatomic) NSString *baseUrl;
@property (strong,nonatomic) NSString *pakageName;

@end

@implementation DJNetworkManager

+ (void)homeDigitalListWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort  success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homeDigitalListWithOffset:offset length:length sort:sort success:success failure:failure];
}

/// MARK: 数字阅读图书详情
+ (void)homeDigitalDetailWithId:(NSString *)id success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homeDigitalDetailWithId:id success:success failure:failure];
}

+ (void)homePointNewsDetailWithId:(NSInteger)id type:(DJDataPraisetype)type success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[self sharedInstance] homePointNewsDetailWithId:id type:type success:success failure:failure];
}

+ (void)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(DJDataPraisetype)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect{
    [[DJNetworkManager sharedInstance] homeLikeSeqid:seqid add:add praisetype:praisetype success:success failure:failure collect:collect];
}

+ (void)homeChairmanPoineNewsClassid:(NSInteger)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] homeChairmanPoineNewsClassid:classid offset:offset length:length sort:sort success:success failure:failure];
}

+ (void)homeSearchWithString:(NSString *)string type:(NSInteger)type offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] homeSearchWithString:string type:type offset:offset length:length sort:sort success:success failure:failure];
}
/// MARK: 首页接口
+ (void)homeIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] homeIndexWithSuccess:success failure:failure];
}

/// MARK: -----分割线-----
- (void)userLoginWithTel:(NSString *)tel pwd_md5:(NSString *)pwd_md5 success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    /**
     type
     0: token登陆
     1: 密码登陆
     token 应该去掉，应为token是登陆成功服务器返回的，所以，这里接口设计的不够准确
     */
    
    NSDictionary *param = @{@"phone":tel,
                            @"password":pwd_md5,
                            @"type":@""
                            };
    [self sendTableWithiName:@"/frontUserinfo/login" param:param needUserid:NO success:success failure:failure];
}
- (void)userActivationWithTel:(NSString *)tel oldPwd:(NSString *)oldPwd pwd:(NSString *)pwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"phone":tel,
                            @"oldpassword":oldPwd,
                            @"password":pwd
                            };
    [self sendTableWithiName:@"/frontUserinfo/activation" param:param needUserid:NO success:success failure:failure];
}

- (void)homeDigitalListWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{};
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontEbook/selectList" param:param success:success failure:failure];
}
- (void)homeDigitalDetailWithId:(NSString *)id success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"seqid":id};
    [self sendPOSTRequestWithiName:@"/frontEbook/select" param:param success:success failure:failure];
}
- (void)homePointNewsDetailWithId:(NSInteger)id type:(DJDataPraisetype)type success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"seqid":[NSString stringWithFormat:@"%ld",id],
                            @"type":[NSString stringWithFormat:@"%ld",type]
                            };
    [self sendPOSTRequestWithiName:@"/frontNews/selectDetail" param:param success:success failure:failure];
}
- (void)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(DJDataPraisetype)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect{
    NSString *iName = nil;
    NSString *type = nil;
    if (collect) {
        NSLog(@"收藏接口 -- ");
        iName = @"/frontUserCollections/add";
        type = @"cellectiontype";
    }else{
        iName = @"/frontUserPraises/add";
        type = @"praisetype";
    }
    NSDictionary *dict = @{@"addordel":[NSString stringWithFormat:@"%d",add],
                           @"seqid":seqid,
                           type:[NSString stringWithFormat:@"%ld",praisetype]};
    [self sendPOSTRequestWithiName:iName param:dict success:success failure:failure];
}
- (void)homeChairmanPoineNewsClassid:(NSInteger)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *dict = @{@"classid":[NSString stringWithFormat:@"%ld",classid],
                           };
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontNews/selectList" param:dict success:success failure:failure];
}
- (void)homeSearchWithString:(NSString *)string type:(NSInteger)type offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSString *type_string = [NSString stringWithFormat:@"%ld",type];
    NSDictionary *dict = @{@"type":type_string,
                           @"search":string};
    [self commenPOSTWithOffset:offset length:length sort:sort iName:@"/frontIndex/lectureSearch" param:dict success:success failure:failure];
}
- (void)homeIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"test":@"home"};
    [self sendPOSTRequestWithiName:@"/frontIndex/index" param:param success:success failure:failure];
}
/**
 MARK: 上传表单数据的统一方法
 @param iName 接口名
 @param param 参数
 @param needUserid 是否需要用户id，传NO表示不需要
 @param success 成功回调
 @param failure 失败回调
 */
- (void)sendTableWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    /// 添加统一参数
    NSMutableDictionary *paramMutable = [self unitParamDictWithDict:param];
    if (!needUserid) {
        [paramMutable removeObjectForKey:param_key_userid];
    }
    
    /// 拼接请求链接
    NSString *url = [NSString stringWithFormat:@"%@%@%@",self.baseUrl,self.pakageName,iName];
    
    /// 获取最终参数
    NSMutableDictionary *argum = [self terParamWithUnitParam:paramMutable.copy];
    
    NSLog(@"arguments -- %@",argum);
    NSLog(@"requesturl: %@",url);
    [[LGNetworkManager sharedInstance] sendPOSTRequestWithUrl:url param:argum completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"DJNetworkManager.responseObject -- %@",responseObject);
        
        if (error) {
            if (failure) failure(error);
        }else{
            NSInteger result = [responseObject[@"result"] integerValue];
            NSString *msg = responseObject[@"msg"];
            
            id jsonString = responseObject[@"returnJson"];
            if ([jsonString isKindOfClass:[NSNull class]]) {
                NSLog(@"returnJsonisNSNull ");
            }else{
                NSData *data = [responseObject[@"returnJson"] dataUsingEncoding:NSUTF8StringEncoding];
                id returnJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (result == 0) {/// 成功
                    if (success) success(returnJson);
                }else{
                    NSDictionary *errorDict = @{@"msg":msg,
                                                @"result":@(result)
                                                };
                    if (failure) failure(errorDict);
                }
            }
        }
    }];
}

/// MARK: 分页接口统一调用此方法
- (void)commenPOSTWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort iName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSString *offset_string = [NSString stringWithFormat:@"%ld",offset];
    NSString *length_string = [NSString stringWithFormat:@"%ld",length];
    NSString *sort_string = [NSString stringWithFormat:@"%ld",sort];
    NSMutableDictionary *paramMutable = [NSMutableDictionary dictionaryWithDictionary:param];
    paramMutable[@"offset"] = offset_string;
    paramMutable[@"length"] = length_string;
    paramMutable[@"sort"] = sort_string;
    [self sendPOSTRequestWithiName:iName param:paramMutable success:success failure:failure];
}
/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    /// 添加统一参数
    NSMutableDictionary *paramMutable = [self unitParamDictWithDict:param];
    
    /// 拼接请求链接
    NSString *url = [NSString stringWithFormat:@"%@%@%@",self.baseUrl,self.pakageName,iName];
    
    /// 获取最终参数
    NSMutableDictionary *argum = [self terParamWithUnitParam:paramMutable.copy];

    NSLog(@"arguments -- %@",argum);
    NSLog(@"requesturl: %@",url);
    [[LGNetworkManager sharedInstance] sendPOSTRequestWithUrl:url param:argum completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) { 
        NSLog(@"DJNetworkManager.responseObject -- %@",responseObject);
        
        if (error) {
//            if (failure) failure(error);
            /// MARK: 回调缓存数据
            [self callBackCacheJsonObjWithiName:iName argum:argum success:success failure:failure];

        }else{
            NSInteger result = [responseObject[@"result"] integerValue];
//            NSString *msg = responseObject[@"msg"];
            
            id jsonString = responseObject[@"returnJson"];
            if ([jsonString isKindOfClass:[NSNull class]]) {
                NSLog(@"returnJsonisNSNull ");
            }else{
                NSData *data = [responseObject[@"returnJson"] dataUsingEncoding:NSUTF8StringEncoding];
                id returnJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"jsonstring -- %@",responseObject[@"returnJson"]);
                NSLog(@"returnJson_class -- %@",[returnJson class]);
                
                /// MARK: 写入缓存数据
                [LGNetworkCache lg_save_asyncJsonToCacheFile:returnJson URLString:iName params:argum];
                if (result == 0) {/// 成功
                    if (success) success(returnJson);
                }else{
//                    NSDictionary *errorDict = @{@"msg":msg,
//                                                @"result":@(result)
//                                                };
//                    if (failure) failure(errorDict);
                    /// MARK: 回调缓存数据
                    [self callBackCacheJsonObjWithiName:iName argum:argum success:success failure:failure];
                }
            }
        }
    }];
}
/// MARK: 获取缓存数据
- (void)callBackCacheJsonObjWithiName:(NSString *)iName argum:(id)argum success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    id cacheJson = [LGNetworkCache lg_cache_jsonWithURLString:iName params:argum];
    if (cacheJson) {
        if (success) success(cacheJson);
    }else{
        if (failure) failure(@"网络异常");
    }
}
/** 添加统一的参数 */
- (NSMutableDictionary *)unitParamDictWithDict:(NSDictionary *)param{
    NSMutableDictionary *paramMutable = [NSMutableDictionary dictionaryWithDictionary:param];
    paramMutable[@"imei"] = @"imei";
    paramMutable[@"imsi"] = @"imsi";
    paramMutable[param_key_userid] = @"1";/// TODO: 获取本地userid
    return paramMutable;
}
/** 返回最终的请求参数 */
- (NSMutableDictionary *)terParamWithUnitParam:(NSDictionary *)unitParam{
    NSMutableDictionary *argum = [NSMutableDictionary dictionaryWithCapacity:10];
    /// TODO: 计算param 的 MD5
    argum[@"params"] = unitParam;
    argum[@"md5"] = @"md5";
    return argum;
}

/// MARK: URL
- (NSString *)baseUrl{
    if (!_baseUrl) {
//        _baseUrl = @"http://192.168.10.108:8080/";
        _baseUrl = @"http://123.59.197.176:8080/";
    }
    return _baseUrl;
}
- (NSString *)pakageName{
    if (!_pakageName) {
        _pakageName = @"APMKAFService";
    }
    return _pakageName;
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
