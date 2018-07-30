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
    /// 题干
    ExamSingleLineTypeContent,
    /// 选项
    ExamSingleLineTypeOption,
    /// 答案
    ExamSingleLineTypeAnswer
};
typedef NS_ENUM(NSUInteger, ExamSingleAnswer) {
    ExamSingleAnswerA,
    ExamSingleAnswerB,
    ExamSingleAnswerC,
    ExamSingleAnswerD
};

@interface OLExamSingleLineModel : LGBaseModel

//{
//    "creatorid":1,
//    "status":1
//},

/** YES: 表示该选项是正确选项 */
@property (assign,nonatomic) BOOL isright;
/** 正确返回1，错误返回-1 */
@property (assign,nonatomic) NSInteger optionValue;
/** 选项描述 */
@property (strong,nonatomic) NSString *options;
@property (strong,nonatomic) NSString *createdtime;
@property (assign,nonatomic) NSInteger type;
@property (assign,nonatomic) NSInteger subjectid;
/// ----------------------以上是新加属性


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
