//
//  OLExamSingleLineModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 单行model，表示题干 或者 选项

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, ExamSingleLineType) {
    ExamSingleLineTypeContent,/// 题干
    ExamSingleLineTypeOption/// 选项
};

@interface OLExamSingleLineModel : LGBaseModel

#pragma mark - 状态
@property (assign,nonatomic) ExamSingleLineType lineType;
/** 是否选中 */
@property (assign,nonatomic,getter=isSelected) BOOL selected;
/** 是否多选 */
@property (assign,nonatomic,getter=isChoiceMutiple) BOOL choiceMutiple;

#pragma mark - 数据
@property (copy,nonatomic) NSString *questionContent;
@property (copy,nonatomic) NSString *optionContent;
@property (assign,nonatomic) NSInteger answer;

@end
