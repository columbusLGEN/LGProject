//
//  CacheDataSource.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "CacheDataSource.h"

@implementation CacheDataSource

CM_SINGLETON_IMPLEMENTION(CacheDataSource)

#pragma mark -
#pragma mark - init & dealloc

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark -
#pragma mark - Public Method

- (void)setCache:(id)data withCacheKey:(NSString *)cacheKey {
    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [[NSUserDefaults standardUserDefaults] setObject:cacheData forKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)loadCacheWithCacheKey:(NSString *)cacheKey
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:cacheKey]];
}

- (void)clearAllCache
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

#pragma mark -
#pragma mark - pravite methods

@end
