//
//  Model.m
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 Libc. All rights reserved.
//

#import "Model.h"

@implementation Model

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
