//
//  EDJMicroBuildModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 党建要闻模型

#import "EDJMicroPartyLessionSubModel.h"
@class EDJMicroPartyLessionSubModel;

@interface EDJMicroBuildModel : EDJMicroPartyLessionSubModel

@property (strong,nonatomic) NSArray *imgs;
@property (assign,nonatomic) BOOL showInteractionView;

@end
