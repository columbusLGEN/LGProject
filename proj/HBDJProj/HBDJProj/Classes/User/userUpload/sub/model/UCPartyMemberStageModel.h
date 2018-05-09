//
//  UCPartyMemberStageModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, PartyMemberModelState) {
    PartyMemberModelStateDefault,/// 默认
    PartyMemberModelStateEditNormal,/// 编辑普通
    PartyMemberModelStateEditSelected/// 编辑选中
};

@interface UCPartyMemberStageModel : LGBaseModel

@property (assign,nonatomic) NSInteger imgCount;
/** 模型状态，默认，编辑常规，编辑选中 */
@property (assign,nonatomic) PartyMemberModelState state;

@end
