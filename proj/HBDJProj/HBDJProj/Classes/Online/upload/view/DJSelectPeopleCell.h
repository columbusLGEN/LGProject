//
//  DJSelectPeopleCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class DJSelectPeopleModel;

static NSString * const selectPeopleCell = @"DJSelectPeopleCell";

@interface DJSelectPeopleCell : LGBaseTableViewCell
@property (strong,nonatomic) DJSelectPeopleModel *model;

@end
