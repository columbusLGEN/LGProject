//
//  LGRequestModel.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/20.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LGRequestModel;

//static NSString * hostURL = @"";

typedef void(^LGRequestSuccess)(LGRequestModel *requestModel);
typedef void(^LGRequestFailure)(NSError *error,NSInteger code,NSURLSessionTask *task);

@interface LGRequestModel : NSObject

/** method */
@property (strong,nonatomic) NSString *method;
/** 请求链接 */
@property (strong,nonatomic) NSString *url;
/** 请求参数 */
@property (strong,nonatomic) id param;
/** 请求task */
@property (strong,nonatomic) NSURLSessionDataTask *task;
@property (copy,nonatomic) LGRequestSuccess successBolck;
@property (copy,nonatomic) LGRequestFailure failureBlock;
/** 服务器返回值 */
@property (strong,nonatomic) id responseObject;
/** 服务器报错信息 */
@property (strong,nonatomic) NSString *msg;
/** 接口名 */
@property (strong,nonatomic) NSString *portName;

@end


NS_ASSUME_NONNULL_END
