//
//  LGNetworkCache.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2018/1/17.
//  Copyright © 2018年 retech. All rights reserved.
//

#import "LGNetworkCache.h"
#import "XHNetworkCache.h"

@implementation LGNetworkCache

+ (void)lg_save_asyncJsonToCacheFile:(id)json URLString:(NSString *)URLString params:(id)params{
    [XHNetworkCache save_asyncJsonResponseToCacheFile:json andURL:URLString params:params completed:^(BOOL result) {
        NSString *cachePath = [XHNetworkCache cachePath];
//        NSLog(@"cacheresult:%d -- path:%@",result,cachePath);
    }];
    
    
}
+ (id)lg_cache_jsonWithURLString:(NSString *)URLString params:(id)params{
    return [XHNetworkCache cacheJsonWithURL:URLString params:params];
}
+ (void)lg_clear_cache{
    [XHNetworkCache clearCache];
}

@end
