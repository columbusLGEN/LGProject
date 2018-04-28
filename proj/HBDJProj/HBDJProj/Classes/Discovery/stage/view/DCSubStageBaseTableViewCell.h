//
//  DCSubStageBaseTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class DCSubStageModel;

static NSString * withoutImgCell = @"DCSubStageWithoutImgCell";
static NSString * oneImgCell = @"DCSubStageOneImgCell";
static NSString * fourImgCell = @"DCSubStageFourImgCell";
static NSString * threeImgCell = @"DCSubStageThreeImgCell";

@interface DCSubStageBaseTableViewCell : LGBaseTableViewCell

@property (strong,nonatomic) DCSubStageModel *model;

@end
