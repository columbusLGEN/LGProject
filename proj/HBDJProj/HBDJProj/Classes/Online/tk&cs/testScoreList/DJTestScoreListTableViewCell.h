//
//  DJTestScoreListTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class DJTestScoreListModel;

static NSString * testScoreListCell = @"DJTestScoreListTableViewCell";

@interface DJTestScoreListTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) DJTestScoreListModel *model;

@end
