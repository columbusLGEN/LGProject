//
//  DJThoughtReportDetailTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class DJThoughtReportDetailTableViewCell,DJThoughtReportDetailModel;

static NSString * const trdHeaderCell = @"DJThoughtReportDetailHeaderCell";
static NSString * const trdTextCell = @"DJThoughtReportDetailTextCell";
static NSString * const trdNineImageCell = @"DJThoughtReportDetailNineImageCell";

@protocol DJThoughtReportDetailTableViewCellDelegate <NSObject>
@optional
- (void)nineImageClick:(DJThoughtReportDetailTableViewCell *)cell index:(NSInteger)index;

@end

@interface DJThoughtReportDetailTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) DJThoughtReportDetailModel *model;

@end
