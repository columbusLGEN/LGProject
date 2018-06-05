
//
//  EDJHomeIndexRequest.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJHomeIndexRequest.h"

@implementation EDJHomeIndexRequest

- (NSString *)requestUrl{
    return @"/frontIndex/index";
}

- (NSMutableDictionary *)subParams{
    NSMutableDictionary *dict = [super subParams];
    dict[@"test"] = @"home";
    return dict;
}

@end
