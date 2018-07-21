//
//  DJUploadMindReportCoverCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadMindReportBaseCell.h"

@class DJUploadMindReportCoverCell;

@protocol DJUploadMindReportCoverCellDelegate <NSObject>
- (void)addCoverClick:(DJUploadMindReportCoverCell *)cell;

@end

@interface DJUploadMindReportCoverCell : DJUploadMindReportBaseCell
@property (weak,nonatomic) id<DJUploadMindReportCoverCellDelegate> delegate;

@end
