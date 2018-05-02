//
//  HPPointNewsHeader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPointNewsHeader.h"

@implementation HPPointNewsHeader

+ (instancetype)pointNewsHeader{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPPointNewsHeader" owner:nil options:nil] lastObject];
}
@end
