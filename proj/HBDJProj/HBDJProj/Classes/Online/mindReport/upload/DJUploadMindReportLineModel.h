//
//  DJUploadMindReportLineModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUploadTableModel.h"

typedef NS_ENUM(NSUInteger, DJUploadMindReportLineType) {
    DJUploadMindReportLineTypeText,
    DJUploadMindReportLineTypeCover,
    DJUploadMindReportLineTypeImage,
};

@interface DJUploadMindReportLineModel : DJOnlineUploadTableModel
@property (assign,nonatomic) DJUploadMindReportLineType lineType;

@end
