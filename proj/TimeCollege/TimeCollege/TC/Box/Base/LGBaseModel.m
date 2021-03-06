//
//  LIGBaseModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@implementation LGBaseModel

//+ (instancetype)modelWithResponseObject:(id)object{
//    return [self mj_objectWithKeyValues:object];
//}


+ (NSArray *)loadLocalPlistWithPlistName:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *destine = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < array.count; i++) {
        id obj = array[i];
        [destine addObject:[self mj_objectWithKeyValues:obj]];
    }
    return destine.copy;
}

@end
