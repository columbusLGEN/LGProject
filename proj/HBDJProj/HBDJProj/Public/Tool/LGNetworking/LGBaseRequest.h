//
//  LGBaseRequest.h
//  NetDemo
//
//  Created by Peanut Lee on 2018/5/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 暂时只有 get 和 post ，其他的待后续用到的时候再扩展
typedef NS_ENUM(NSUInteger, LGRequestMethod) {
    LGRequestMethodGET,
    LGRequestMethodPOST
};

typedef NS_ENUM(NSUInteger, LGRequestSerializerType) {
    LGRequestSerializerTypeHTTP,
    LGRequestSerializerTypeJSON,
};

typedef NS_ENUM(NSUInteger, LGResponseSerializerType) {
    LGResponseSerializerTypeHTTP,
    LGResponseSerializerTypeJSON,
    LGResponseSerializerTypeXML,
};


typedef void(^LGRequestSuccess)(id responseObject);
typedef void(^LGRequestFailure)(id faillureObject);
typedef void(^NetworkFailure)(NSError *error);
typedef void(^serializerFailure)(NSError *serializerError);

@interface LGBaseRequest : NSObject

@property (nonatomic, strong) NSURLSessionTask *requestTask;
/** 请求成功 */
@property (copy,nonatomic) LGRequestSuccess requestSuccess;
/** 请求失败 */
@property (copy,nonatomic) LGRequestFailure requestFailure;
/** 网络连接失败 */
@property (copy,nonatomic) NetworkFailure networkFailure;
/** 序列化失败 */
@property (copy,nonatomic) serializerFailure serializerFailure;

- (instancetype)initWithSuccess:(LGRequestSuccess)success failure:(LGRequestFailure)failure networkFailure:(NetworkFailure)networkFailure;

/** 请求方法 */
- (LGRequestMethod)requestMethod;
/// 包名
- (NSString *)packageName;
/// 接口名
- (NSString *)requestUrl;
/** 请求参数 */
- (id)requestArguments;
- (NSMutableDictionary *)subParams;
/** request serializer type */
- (LGRequestSerializerType)requestSerializerType;
/** 返回值数据结构类型，JSON,XML,二进制 */
- (LGResponseSerializerType)responseSerializerType;
/** 开始请求 */
- (void)start;

@end
