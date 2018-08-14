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
    LGDeviecType_iPhoneX,/// 表示iPhone X
    LGDeviecType_iPad
};

@interface LGDevice : NSObject

+ (BOOL)isiPad;
/** 当前设备是否iPhone X */
+ (BOOL)isiPhoneX;
/// 当前设备类型，启动时获取一次，然后记录在该属性里
@property (assign,nonatomic,readonly) LGDeviecType currentDeviceType;

- (void)lg_currentDeviceType;

+ (instancetype)sharedInstance;
@end
