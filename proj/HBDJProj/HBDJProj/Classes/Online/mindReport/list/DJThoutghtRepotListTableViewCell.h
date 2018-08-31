//
//  DJThoutghtRepotListTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectTableViewCell.h"
@class DJThoutghtRepotListModel;

static NSString * const thoughtRepotrListCell = @"DJThoutghtRepotListTableViewCell";

@interface DJThoutghtRepotListTableViewCell : DJUcMyCollectTableViewCell
@property (strong,nonatomic) DJThoutghtRepotListModel *model;
@property (strong,nonatomic) DJThoutghtRepotListModel *ucmuModel;

@end
