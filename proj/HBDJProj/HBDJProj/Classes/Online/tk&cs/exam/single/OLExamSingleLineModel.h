//
//  OLExamSingleLineModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 单行model，表示题干 或者 选项

#import "LGBaseModel.h"
@class OLExamSingleModel;

typedef NS_ENUM(NSUInteger, ExamSingleLineType) {
    ExamSingleLineTypeContent,/// 题干
    ExamSingleLineTypeOption,/// 选项
    ExamSingleLineTypeAnswer/// 答案
};
typedef NS_ENUM(NSUInteger, ExamSingleAnswer) {
    ExamSingleAnswerA,
    ExamSingleAnswerB,
    ExamSingleAnswerC,
    ExamSingleAnswerD
};

@interface OLExamSingleLineModel : LGBaseModel

#pragma mark - 状态
@property (assign,nonatomic) ExamSingleLineType lineType;
/** 是否选中 */
@property (assign,nonatomic) BOOL selected;
/** 是否多选 */
@property (assign,nonatomic) BOOL choiceMutiple;

#pragma mark - 数据
/** 题干描述 */
@property (copy,nonatomic) NSString *questionContent;
/** 选项描述 */
@property (copy,nonatomic) NSString *optionContent;
/** 该行代表的选项
 0 A
 1 B
 2 C
 3 D
 /// 如果是答案行，该属性表示正确答案
 */
@property (assign,nonatomic) ExamSingleAnswer repreAnswer;

/** 所属题目 */
@property (strong,nonatomic) OLExamSingleModel *belongTo;




@end
