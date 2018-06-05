//
//  HPSearchRequest.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPSearchRequest.h"

@implementation HPSearchRequest{
    NSString *_content;
    NSString *_type;/// 0:全部 1: 微党课, 2: 党建要闻
    NSString *_offset;
    NSString *_length;
}

- (id)initWithContent:(NSString *)contetnt type:(NSInteger)type offset:(NSString *)offset length:(NSString *)length success:(LGRequestSuccess)success failure:(LGRequestFailure)failure networkFailure:(NetworkFailure)networkFailure{
    if (self = [super initWithSuccess:success failure:failure networkFailure:networkFailure]) {
        _content = contetnt;
        _type = [NSString stringWithFormat:@"%ld",type];
        _offset = offset;
        _length = length;
        if ([length isEqualToString:@""] || length == nil) {
            length = @"10";
        }
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/frontIndex/lectureSearch";
}

- (NSMutableDictionary *)subParams{
    NSMutableDictionary *dict = [super subParams];
    dict[@"search"] = _content;
    dict[@"type"] = _type;
    dict[@"sort"] = @"0";
    dict[@"offset"] = _offset;
    dict[@"length"] = _length;
    return dict;
}

@end
