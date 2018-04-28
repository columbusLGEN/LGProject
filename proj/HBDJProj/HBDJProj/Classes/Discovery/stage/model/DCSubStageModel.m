//
//  DCSubStageModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageModel.h"

@implementation DCSubStageModel

- (CGFloat)cellHeight{
    CGFloat defaultHeight = 96;
    switch (self.imgCount) {
        case 0:
            return defaultHeight;
            break;
        case 1:
            return 144;
            break;
        case 3:
            return 229;
            break;
        default:
            return defaultHeight;
            break;
    }
}

@end
