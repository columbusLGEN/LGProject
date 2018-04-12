//
//  EDJUserCenterHomePageModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJUserCenterHomePageModel.h"

@implementation EDJUserCenterHomePageModel

+ (NSArray *)loadLocalPlist{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserCenterHomeForm" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *destine = [NSMutableArray arrayWithCapacity:10];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [destine addObject:(EDJUserCenterHomePageModel *)[self mj_objectWithKeyValues:obj]];
    }];
    return destine.copy;
}


@end
