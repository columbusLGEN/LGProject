//
//  EDJMicroBuildModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroBuildModel.h"
#import "EDJMicroPartyLessionSubModel.h"

@implementation EDJMicroBuildModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"subNews":@"EDJMicroPartyLessionSubModel"};
}

/// testcode
- (NSArray<EDJMicroPartyLessionSubModel *> *)subNews{
    return @[[EDJMicroPartyLessionSubModel new],[EDJMicroPartyLessionSubModel new],[EDJMicroPartyLessionSubModel new]];
}

@end
