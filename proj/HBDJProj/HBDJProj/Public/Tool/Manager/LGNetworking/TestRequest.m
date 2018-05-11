//
//  TestRequest.m
//  NetDemo
//
//  Created by Peanut Lee on 2018/5/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest{
    NSString *_userId;
}

- (instancetype)initWithUserId:(NSString *)userId{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/books/index";
}

- (id)subParams{
    NSDictionary *dict = @{@"imei":@"imei"
                           ,@"imsi":@"imsi"
                           ,@"userId":_userId};
    return dict;
}

@end
