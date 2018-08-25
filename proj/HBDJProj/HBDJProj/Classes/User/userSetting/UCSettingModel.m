//
//  UCSettingModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCSettingModel.h"

@implementation UCSettingModel

+ (NSArray *)loadLocalPlist{
    return [self loadLocalPlistWithPlistName:@"UCSetting"];
//    NSArray *originArray = [self loadLocalPlistWithPlistName:@"UCSetting"];
//    NSMutableArray *desArray = [NSMutableArray arrayWithArray:originArray];
//    return [desArray subarrayWithRange:NSMakeRange(0, 1)];
//    return [self loadLocalPlistWithPlistName:@"UCSetting"];
}

@end
