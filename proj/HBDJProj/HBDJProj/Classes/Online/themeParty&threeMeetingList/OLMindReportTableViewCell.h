//
//  OLMindReportTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

static NSString * const cellID = @"OLMindReportTableViewCell";

@class OLMindReportModel;

@interface OLMindReportTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) OLMindReportModel *model;

@end
