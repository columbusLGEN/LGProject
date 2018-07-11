//
//  DJUser.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUser.h"
#import <objc/runtime.h>

static NSString *key_suffix = @"_dj";

@implementation DJUser

- (NSString *)userid{
    if (!_userid) {
        _userid =  [[NSUserDefaults standardUserDefaults] objectForKey:[@"seqid" stringByAppendingString:key_suffix]];
    }
    return _userid;
}

- (void)keepUserInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    for (NSString *propertyName in self.propertyArray) {
        NSString *key = [propertyName stringByAppendingString:key_suffix];
        id propertyValue = [self valueForKey:propertyName];
        [ud setValue:propertyValue forKey:key];
    }
    [ud synchronize];
    
}
- (void)getLocalUserInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    for (NSString *propertyName in self.propertyArray) {
        NSString *key = [propertyName stringByAppendingString:key_suffix];
        id propertyValue = [ud valueForKey:key];
        if (propertyValue) {
            [self setValue:propertyValue forKey:propertyName];
//            NSLog(@"%@ - %@",propertyName,[self valueForKey:propertyName]);
        }
    }
    
}
- (void)removeLocalUserInfo{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    for (NSString *propertyName in self.propertyArray) {
        NSString *key = [propertyName stringByAppendingString:key_suffix];
        [ud removeObjectForKey:key];
    }

}

/** 获取类型的所有属性名 */
- (NSArray *)propertyArray{
    u_int count = 0;
    
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    
    NSMutableArray *arrayProperty = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertys[i]);
        [arrayProperty addObject:[NSString stringWithUTF8String:propertyName]];
    }
//    NSLog(@"propertys: %@",arrayProperty);
    return arrayProperty.copy;
}

- (NSString *)filePath{
    /// 每一个用户都保存着 userid_数据.plist 的文件
    return [[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo"] stringByAppendingPathComponent:[NSString stringWithFormat:@"userid_%@.plist",self.seqid]];
}

- (NSString *)degree{
    /** 学位：1高职高专，2专科，3本科，4硕士，5博士及以上 */
    if ([_degree isEqualToString:@"1"]) {
        return @"高职高专";
    }
    if ([_degree isEqualToString:@"2"]) {
        return @"专科";
    }
    if ([_degree isEqualToString:@"3"]) {
        return @"本科";
    }
    if ([_degree isEqualToString:@"4"]) {
        return @"硕士";
    }
    if ([_degree isEqualToString:@"5"]) {
        return @"博士及以上";
    }
    return _degree;
}

- (NSString *)gender{
    if ([_gender isEqualToString:@"1"]) {
        return @"男";
    }
    if ([_gender isEqualToString:@"0"]) {
        return @"女";
    }
    return _gender;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
