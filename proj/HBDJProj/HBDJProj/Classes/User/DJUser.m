//
//  DJUser.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUser.h"

@interface DJUser ()


@end

@implementation DJUser


+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
