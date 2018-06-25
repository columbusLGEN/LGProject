//
//  EDJMicroBuildModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroBuildModel.h"
#import "DJDataBaseModel.h"

@implementation EDJMicroBuildModel

@synthesize cover = _cover;

- (NSArray *)imgs{
    if (!_imgs) {
        _imgs = [_cover componentsSeparatedByString:@","];
    }
    return _imgs;
}


@end
