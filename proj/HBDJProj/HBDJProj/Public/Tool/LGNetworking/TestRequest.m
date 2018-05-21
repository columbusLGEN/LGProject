//
//  TestRequest.m
//  NetDemo
//
//  Created by Peanut Lee on 2018/5/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest{
    NSString *_test;
}

- (instancetype)initWithTest:(NSString *)test{
    if (self = [super init]) {
        _test = test;
    }
    return self;
}

- (NSString *)requestUrl{
//    return @"/user/selectCountry";
    return @"/frontLabel/select";
//    return @"/carouselfigure/select";
}

- (id)subParams{
    NSDictionary *dict = @{@"imei":@"imei"
                           ,@"imsi":@"imsi"
                           };
    return dict;
}

@end
