//
//  LGDevice.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGDevice.h"

@interface LGDevice ()


@end

@implementation LGDevice

+ (BOOL)isiPhoneX{
    return ([LGDevice sharedInstance].currentDeviceType == LGDeviecType_iPhoneX);
}

- (void)lg_currentDeviceType{
    if (kScreenHeight == 812) {
        _currentDeviceType = LGDeviecType_iPhoneX;
    }
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
