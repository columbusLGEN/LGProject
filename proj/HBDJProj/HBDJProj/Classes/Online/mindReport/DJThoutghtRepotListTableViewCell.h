//
//  DJThoutghtRepotListTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class DJThoutghtRepotListModel;

static NSString * const thoughtRepotrListCell = @"DJThoutghtRepotListTableViewCell";

@interface DJThoutghtRepotListTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) DJThoutghtRepotListModel *model;

@end
