//
//  LIGBaseModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@implementation LGBaseModel

- (NSString *)cover{
    if ([_cover componentsSeparatedByString:@","].count == 1) {
        return [[_cover componentsSeparatedByString:@","] firstObject];
    }else{
        return _cover;
    }
}

+ (NSArray *)arrayWithResponseObject:(id)object{
    
    return nil;
}
+ (instancetype)modelWithResponseObject:(id)object{
    return [self mj_objectWithKeyValues:object];
}

+ (NSArray *)loadLocalPlist{
    return nil;
}
+ (NSArray *)loadLocalPlistWithPlistName:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *destine = [NSMutableArray arrayWithCapacity:10];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [destine addObject:[self mj_objectWithKeyValues:obj]];
    }];
    return destine.copy;
}

@end
