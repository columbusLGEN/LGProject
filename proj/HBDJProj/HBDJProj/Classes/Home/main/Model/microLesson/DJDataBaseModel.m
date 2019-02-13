//
//  EDJMicroPartyLessionSonModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJDataBaseModel.h"

@implementation DJDataBaseModel

@synthesize createdtime = _createdtime;

- (NSInteger)praisecount{
    if (_praisecount < 0) {
        _praisecount = 0;
    }
    return _praisecount;
}
- (NSInteger)collectioncount{
    if (_collectioncount < 0) {
        _collectioncount = 0;
    }
    return _collectioncount;
}
- (NSInteger)playcount{
    if (_playcount < 0) {
        _playcount = 0;
    }
    return _playcount;
}

- (NSString *)createdDate{
    if (!_createdDate) {
//        _createdDate = [_createdtime timestampToMin];
        _createdDate = [_createdtime timestampToDate];
        
    }
    return _createdDate;
}

- (NSString *)debugDescription {
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSString class]]) {
        return self.debugDescription;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properites = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properites[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?: @"nil";
        [dic setValue:value forKey:name];
    }
    free(properites);
    return [NSString stringWithFormat:@"%@(%p): %@", [self class], self, dic];
    
}

@end
