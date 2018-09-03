//
//  OLVoteListModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteListModel.h"

@implementation OLVoteListModel

- (NSString *)endtime{
    if (_endtime.length > length_timeString) {
        _endtime = [_endtime substringToIndex:(length_timeString + 1)];
    }
    return _endtime;
}


@end
