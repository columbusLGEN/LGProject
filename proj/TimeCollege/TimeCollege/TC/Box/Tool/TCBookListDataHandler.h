//
//  TCBookListDataHandler.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/9.
//  Copyright © 2019 lee. All rights reserved.
//

/**
 请求数据的类：
 1.发送请求前：搜索 or 列表
 2.接收到服务器回调之后：成功 or 失败回调
 */

#import <Foundation/Foundation.h>

#define addParamKey_offset   @"offset"
#define addParamKey_page     @"page"
#define addParamKey_length   @"length"

typedef NS_ENUM(NSUInteger, TCBookListRequestType) {
    TCBookListRequestTypeSearch_bookrack,    /// 搜索 我的书橱
    TCBookListRequestTypeSearch_school,      /// 搜索 学校书橱
    TCBookListRequestTypeDigital,            /// 数字教材
    TCBookListRequestTypeEBook               /// 电子图书
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^bldhSuccess)(id resobj);
typedef void(^bldhFailure)(id errobj);

@interface TCBookListDataHandler : NSObject

- (void)requestDataWithType:(TCBookListRequestType)type addParam:(id)addParam success:(bldhSuccess)success failure:(bldhFailure)failure;

@end

NS_ASSUME_NONNULL_END
