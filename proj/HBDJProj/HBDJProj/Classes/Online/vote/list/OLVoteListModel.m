//
//  OLVoteListModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteListModel.h"

@implementation OLVoteListModel

//- (NSString *)starttime{
//    if (_starttime.length > length_timeString) {
//        _starttime = [_starttime substringToIndex:(length_timeString + 1)];
//    }
//    return _starttime;
//}

- (NSString *)endtime{
    NSLog(@"endtime: %@",_endtime);
    if (_endtime.length > length_timeString) {
        _endtime = [_endtime substringToIndex:(length_timeString + 1)];
    }
    return _endtime;
}

//- (BOOL)isEnd{
//    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = NSDateFormatter.new;
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *currentDate = [formatter stringFromDate:date];
//
//    if ([_endtime compare:currentDate] == -1) {
//        return YES;
//    }
//    return NO;
//}

@end
