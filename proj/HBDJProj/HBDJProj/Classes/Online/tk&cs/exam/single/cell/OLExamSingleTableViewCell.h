//
//  OLExamSingleTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

static NSString * const examSingleStemCell = @"OLExamSingleStemCell";
static NSString * const examSingleOptionCell = @"OLExamSingleOptionCell";

@class OLExamSingleLineModel;

@interface OLExamSingleTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) OLExamSingleLineModel *model;

@end
