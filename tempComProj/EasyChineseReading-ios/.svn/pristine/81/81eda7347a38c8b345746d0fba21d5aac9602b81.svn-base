//
//  CacheDataSource.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CACHE_KEY_USER_MODEL @"CACHE_KEY_USER_MODEL"

@interface CacheDataSource : NSObject

CM_SINGLETON_INTERFACE(CacheDataSource)

/* 本地缓存 */

// 保存缓存数据

/**
 保存缓存数据

 @param data      缓存的数据
 @param cacheKey  key
 */
- (void)setCache:(id)data withCacheKey:(NSString *)cacheKey;

/**
 读取缓存数据

 @param cacheKey  key
 @return data     缓存的数据
 */
- (id)loadCacheWithCacheKey:(NSString *)cacheKey;

/**
 清除持久域
 */
- (void)clearAllCache;

/**
 *  清除所有的存储本地的数据
 */
- (void)clearAllUserDefaultsData;

@end
