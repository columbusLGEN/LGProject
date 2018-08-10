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

@interface OLExamSingleLineModel : LGBaseModel

/** YES: 表示该选项是正确选项 */
@property (assign,nonatomic) BOOL isright;
/** 正确返回1，错误返回-1 */
@property (assign,nonatomic) NSInteger optionValue;
/** 接口返回的选项描述 */
@property (strong,nonatomic) NSString *options;
@property (strong,nonatomic) NSString *createdtime;
/** 是否是用户所选答案 */
@property (assign,nonatomic) NSInteger type;
@property (assign,nonatomic) NSInteger subjectid;
/** A B C D ... */
@property (strong,nonatomic) NSString *answerString;
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
/** 本地需要显示的选项描述 例如 A options */
@property (copy,nonatomic) NSString *optionContent;

/** 所属题目 */
@property (strong,nonatomic) OLExamSingleModel *belongTo;


@end
