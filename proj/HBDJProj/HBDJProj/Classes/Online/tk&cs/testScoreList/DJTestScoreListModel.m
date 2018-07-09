//
//  DJTestScoreListModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJTestScoreListModel.h"

@implementation DJTestScoreListModel

- (NSString *)correctRate{
    return [[[NSString stringWithFormat:@"%f",[_correctRate floatValue] * 100] substringToIndex:2] stringByAppendingString:@"%"];
}

@end
