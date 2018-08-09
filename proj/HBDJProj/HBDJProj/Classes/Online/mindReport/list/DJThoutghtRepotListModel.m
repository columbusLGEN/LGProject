//
//  DJThoutghtRepotListModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoutghtRepotListModel.h"

@implementation DJThoutghtRepotListModel

- (NSString *)createdtime{
    if (_createdtime.length > length_timeString_1) {
        _createdtime = [_createdtime substringToIndex:(length_timeString_1 + 1)];
    }
    return _createdtime;
}

@end
