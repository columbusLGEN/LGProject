//
//  EDJMicroBuildModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 党建要闻模型

#import "LGBaseModel.h"
@class EDJMicroPartyLessionSubModel;

@interface EDJMicroBuildModel : LGBaseModel

@property (strong,nonatomic) NSArray *imgs;
@property (strong,nonatomic) NSArray<EDJMicroPartyLessionSubModel *> *subNews;
@property (assign,nonatomic) BOOL showInteractionView;

@end
