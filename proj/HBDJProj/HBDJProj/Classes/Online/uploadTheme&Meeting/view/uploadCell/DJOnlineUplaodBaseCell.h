//
//  DJOnlineUplaodBaseCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class DJOnlineUploadTableModel,DJOnlineUplaodTableViewController;

static NSString * const onlineUplaodBaseCell = @"DJOnlineUplaodBaseCell";

@interface DJOnlineUplaodBaseCell : LGBaseTableViewCell

@property (weak,nonatomic,readonly) UILabel *item;
@property (weak,nonatomic,readonly) UIView *line_sep;

@property (strong,nonatomic) DJOnlineUploadTableModel *model;
@property (strong,nonatomic) NSIndexPath *indexPath;

@property (weak,nonatomic) DJOnlineUplaodTableViewController *vc;

@end
