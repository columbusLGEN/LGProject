//
//  OLExamSingleTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleTableViewCell.h"
#import "OLExamSingleLineModel.h"

@implementation OLExamSingleTableViewCell

+ (NSString *)cellReuseIdWithModel:(OLExamSingleLineModel *)model{
    if (model.lineType == ExamSingleLineTypeContent) {
        /// 题干
        return examSingleStemCell;
    }else{
        /// 选项
        return examSingleOptionCell;
    }
}

@end
