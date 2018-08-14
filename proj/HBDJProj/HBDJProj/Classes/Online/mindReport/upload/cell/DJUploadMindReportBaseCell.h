//
//  DJUploadMindReportBaseCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
static NSString * const uploadMRTextCell = @"DJUploadMindReportTextCell";
static NSString * const uploadMRAddCoverCell = @"DJUploadMindReportCoverCell";
static NSString * const uploadMRAddImageCell = @"DJUploadMindReportImageCell";
static NSString * const uploadPYQImageCell = @"DJUploadPYQImageCell";
static NSString * const uploadPYQTextCell = @"DJUploadPYQTextCell";


@class DJUploadMindReportLineModel;

@interface DJUploadMindReportBaseCell : LGBaseTableViewCell
@property (weak,nonatomic) UIView *colorLump;
@property (weak,nonatomic) UILabel *title;
@property (weak,nonatomic) UIView *line;

@property (strong,nonatomic) DJUploadMindReportLineModel *model;

@end
