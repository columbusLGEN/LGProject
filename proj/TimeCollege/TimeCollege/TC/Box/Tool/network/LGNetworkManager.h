//
//  LGNetworkManager.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/17.
//  Copyright © 2019 lee. All rights reserved.
//

/**
 支持的功能
 * 1.发送请求方法为GET，POST，PUT，DELETE的普通网络请求的功能
 * 2.上传图片,视频等文件(单文件,多文件上传)
 
 
 
 
 * 7.添加请求头（eg.针对一些需要使用token的服务）
 * 8.设置服务器地址
 
 */

#import <Foundation/Foundation.h>
#import "LGRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LGRequestMethod) {
    LGRequestMethodGET,
    LGRequestMethodPOST,
    LGRequestMethodPUT,
    LGRequestMethodDELETE
};

@interface LGNetworkManager : NSObject

/** GET */
- (void)GETWithUrl:(NSString *)url
         parameters:(id)parameters
            success:(LGRequestSuccess)success
            failure:(LGRequestFailure)failure;

/** POST */
- (void)POSTWithUrl:(NSString *)url
          parameters:(id)parameters
             success:(LGRequestSuccess)success
             failure:(LGRequestFailure)failure;

+ (instancetype)sharedNetworkManager;
@end

NS_ASSUME_NONNULL_END
