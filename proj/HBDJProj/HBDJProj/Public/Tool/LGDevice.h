//
//  LGDevice.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LGDeviecType) {
    LGDeviecTypeDefault,
    LGDeviecType_iPhoneX/// 表示iPhone X
};

@interface LGDevice : NSObject

@property (assign,nonatomic,readonly) LGDeviecType currentDeviceType;

- (void)lg_currentDeviceType;

+ (instancetype)sharedInstance;
@end
