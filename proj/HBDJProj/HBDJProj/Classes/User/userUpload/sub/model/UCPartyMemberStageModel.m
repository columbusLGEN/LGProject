//
//  UCPartyMemberStageModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPartyMemberStageModel.h"

@implementation UCPartyMemberStageModel

- (NSInteger)imgCount{
    return arc4random_uniform(3) + 1;
}
@end
