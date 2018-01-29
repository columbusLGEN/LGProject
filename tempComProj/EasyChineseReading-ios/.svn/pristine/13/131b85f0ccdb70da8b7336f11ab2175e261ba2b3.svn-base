//
//  ECRLocationManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRLocationManager : NSObject


/**
 当前位置是否为中国,1是;0否.

 @return 1是;0否.
 */
+ (BOOL)currentLocationIsChina;

/**
 开始定位

 @param cnBlock 成功回调,回调国家名
 */
+ (void)rg_startUpdatingLocationWithBlock:(void (^)(NSString *))cnBlock;

@end


