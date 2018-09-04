//
//  EDJLevelInfoModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJLevelInfoModel.h"

@implementation EDJLevelInfoModel

- (NSString *)unit{
    if (!_unit) {
        if (_integraltype == 1) {
            _unit = @"次";
        }
        if (_integraltype == 2) {
            _unit = @"分钟";
        }
    }
    return _unit;
}

@end
