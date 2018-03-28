//
//  LIGNetworkConfig.m
//  LGProject
//
//  Created by Peanut Lee on 2018/3/19.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LIGNetworkConfig.h"

@interface LIGNetworkConfig ()


@end

@implementation LIGNetworkConfig



+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
