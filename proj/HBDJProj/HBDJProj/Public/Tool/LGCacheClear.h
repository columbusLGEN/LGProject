//
//  LGCacheClear.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LGClearCacheCompletion)(void);
typedef void(^LGClearCacheAlertBack)(UIAlertController *);

@interface LGCacheClear : NSObject

- (void)clearCacheWithAlertCallBack:(LGClearCacheAlertBack)alertCallBack completion:(LGClearCacheCompletion)completion;

- (NSString *)cacheSize;

@end
