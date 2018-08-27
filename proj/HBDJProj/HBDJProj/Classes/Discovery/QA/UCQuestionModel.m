//
//  UCQuestionModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCQuestionModel.h"

@implementation UCQuestionModel

- (NSArray *)tags{
    if (!_tags) {
        _tags = [self.label componentsSeparatedByString:@","];
    }
    return _tags;
}

- (NSString *)tagString{
    if (!_tagString) {
        _tagString = [self.tags componentsJoinedByString:@"  "];
    }
    return _tagString;
}


@end
