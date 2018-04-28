//
//  DCSubPartStateModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateModel.h"

@implementation DCSubPartStateModel

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
            return 201;
            break;
        default:
            return defaultHeight;
            break;
    }
}


@end
