//
//  EDJMicroPartyLessonSubCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

static NSString * const microPartyLessonSubCell = @"EDJMicroPartyLessonSubCell";

@class DJDataBaseModel;

@interface EDJMicroPartyLessonSubCell : LGBaseTableViewCell
@property (strong,nonatomic) DJDataBaseModel *model;

@end
