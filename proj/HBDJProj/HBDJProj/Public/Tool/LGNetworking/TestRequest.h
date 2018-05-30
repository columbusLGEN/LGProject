//
//  TestRequest.h
//  NetDemo
//
//  Created by Peanut Lee on 2018/5/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 测试请求，目前请求接口：首页

#import "LGBaseRequest.h"

@interface TestRequest : LGBaseRequest

- (instancetype)initWithTest:(NSString *)test;

@end
