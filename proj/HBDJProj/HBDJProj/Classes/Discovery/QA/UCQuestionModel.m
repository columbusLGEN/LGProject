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

- (NSString *)tag0{
    if (self.tags.count > 0) {
        if (!_tag0) {
            _tag0 = _tags[0];
        }
    }
    return _tag0;
}
- (NSString *)tag1{
    if (self.tags.count > 1) {
        if (!_tag1) {
            _tag1 = _tags[1];
        }
    }
    return _tag1;
}
- (NSString *)tag2{
    if (self.tags.count > 2) {
        if (!_tag2) {
            _tag2 = _tags[2];
        }
    }
    return _tag2;
}

@end
