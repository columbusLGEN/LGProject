//
//  DCSubStageCommentsCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class DCSubStageCommentsModel;

static NSString * const stageCommentsCell = @"DCSubStageCommentsCell";

@interface DCSubStageCommentsCell : LGBaseTableViewCell
@property (strong,nonatomic) DCSubStageCommentsModel *model;
@end
