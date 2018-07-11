//
//  DJShowThemeMeetingBaseCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class DJOnlineUploadTableModel;

@interface DJShowThemeMeetingBaseCell : LGBaseTableViewCell

@property (weak,nonatomic,readonly) UILabel *item;
@property (weak,nonatomic,readonly) UIView *line_sep;
@property (strong,nonatomic) DJOnlineUploadTableModel *model;

@end
