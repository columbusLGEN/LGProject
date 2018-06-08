//
//  LGNetworkCache.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2018/1/17.
//  Copyright © 2018年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGNetworkCache : NSObject

/**
 *  写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
 *
 *  @param json       要写入的数据(JSON)
 *  @param URLString  数据请求URL
 *  @param params     数据请求URL
 */
+ (void)lg_save_asyncJsonToCacheFile:(id)json URLString:(NSString *)URLString params:(id)params;
/**
 *  获取缓存的对象(同步)
 *  @param URLString 数据请求URL
 *  @param params 数据请求参数
 *  @return 缓存对象
 */
+ (id)lg_cache_jsonWithURLString:(NSString *)URLString params:(id)params;
/** 清除缓存 */
+ (void)lg_clear_cache;

@end
