//
//  EDJHomeModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJHomeModel.h"

@implementation EDJHomeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"imageLoops"  :@"EDJHomeImageLoopModel",
             @"microLessons":@"EDJMicroLessionAlbumModel",
             @"pointNews"   :@"EDJMicroBuildModel",
             @"digitals"    :@"EDJDigitalModel"
             };
}

@end
