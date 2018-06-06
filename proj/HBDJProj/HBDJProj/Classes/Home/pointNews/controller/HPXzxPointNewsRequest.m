//
//  HPXzxPointNewsRequest.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPXzxPointNewsRequest.h"

@implementation HPXzxPointNewsRequest

- (NSString *)requestUrl{
    return @"/frontNews/selectList";
}

- (NSMutableDictionary *)subParams{
    NSMutableDictionary *dict = [super subParams];
//    dict[@"classid"] = @"";
    return dict;
}

@end
