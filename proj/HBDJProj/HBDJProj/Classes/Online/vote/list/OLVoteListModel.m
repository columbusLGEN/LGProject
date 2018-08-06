//
//  OLVoteListModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteListModel.h"

@implementation OLVoteListModel

- (NSString *)starttime{
    if (_starttime.length > 10) {
        _starttime = [_starttime substringToIndex:11];
    }
    return _starttime;
}

- (NSString *)endtime{
    if (_endtime.length > 10) {
        _endtime = [_endtime substringToIndex:11];
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
