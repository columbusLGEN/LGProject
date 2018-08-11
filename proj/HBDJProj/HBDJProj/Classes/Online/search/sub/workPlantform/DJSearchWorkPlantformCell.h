//
//  DJSearchWorkPlantformCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class DJSearchWorkPlantformModel;

static NSString * const searchWPCell = @"DJSearchWorkPlantformCell";

@interface DJSearchWorkPlantformCell : LGBaseTableViewCell
@property (strong,nonatomic) DJSearchWorkPlantformModel *model;

@end
