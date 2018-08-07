//
//  OLExamSingleLineModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleLineModel.h"

@implementation OLExamSingleLineModel

- (NSInteger)optionValue{
    return _isright?1:-1;
}

- (NSString *)optionContent{
    if (!_optionContent) {
        _optionContent = [self.answerString stringByAppendingString:_options?_options:@""];
    }
    return _optionContent;
}

@end
