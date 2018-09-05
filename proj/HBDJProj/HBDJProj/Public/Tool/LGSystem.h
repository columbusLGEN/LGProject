//
//  LGSystem.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGSystem : NSObject
/** 获取 商店中应用版本 */
- (void)getAppStoreVersion;
/** 前往商店下载 */
- (void)openAppStorePage;

@end
