//
//  DJUcMyCollectLessonModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectLessonModel.h"

@implementation DJUcMyCollectLessonModel

- (NSURL *)coverUrl{
    if (!_coverUrl) {
        _coverUrl = [NSURL URLWithString:self.cover];
    }
    return _coverUrl;
}
- (NSString *)plCountString{
    if (!_plCountString) {
        _plCountString = [NSString stringWithFormat:@"%ld",self.playcount];
    }
    return _plCountString;
}

@end
