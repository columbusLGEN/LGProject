//
//  LGSystem.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGSystem : NSObject

/** 对比版本号 */
- (void)bundleAppVersionCompareAppStoreVersionResult:(void(^)(NSInteger result))compareResult;
/** 获取应用商店中版本号 */
- (void)getAppStoreVersion;
/** 前往商店下载页面 */
- (void)openAppStorePage;

@end
