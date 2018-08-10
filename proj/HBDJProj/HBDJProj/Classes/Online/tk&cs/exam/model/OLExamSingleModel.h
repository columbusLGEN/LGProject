//
//  OLExamSingleModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 单页model，表示一道题

#import "LGBaseModel.h"
#import "OLExamSingleLineModel.h"

@class OLTkcsModel;

typedef NS_ENUM(NSUInteger, ExamSingleRespondState) {
    ExamSingleRespondStateDefault,/// 默认状态
    ExamSingleRespondStateCorrect,/// 回答正确
    ExamSingleRespondStateWrong,/// 回答错误
};

@class OLExamSingleLineModel;

@interface OLExamSingleModel : LGBaseModel

/** 用于提交答案的题目id */
@property (strong,nonatomic) NSString *subjectid;


/** 题干 */
@property (strong,nonatomic) NSString *subject;
/** 1:单选 2:多选 */
@property (assign,nonatomic) NSInteger subjecttype;
/** YES: 表示该题是否选对 */
@property (assign,nonatomic) BOOL isright;
/** 0:错误，1:正确，回看试题时判断正误 */
@property (assign,nonatomic) BOOL right;
/** 用户选择的选项(单选) */
@property (strong,nonatomic) OLExamSingleLineModel *selectOption;
/** 多选题用户选择的选项(多选) */
@property (strong,nonatomic) NSMutableArray<OLExamSingleLineModel *> *selectOptions;
/** 题目正确选项数量 */
@property (assign,nonatomic) NSInteger rightOptionCount;
/** 用户所选的值 */
@property (assign,nonatomic) NSInteger selectValue;

@property (strong,nonatomic) NSString *createdtime;
/** 题目选项 */
@property (strong,nonatomic) NSMutableArray<OLExamSingleLineModel *> *frontSubjectsDetail;
@property (strong,nonatomic) NSString *analysis;
@property (strong,nonatomic) NSString *titleid;

/** 是否为第一题 */
@property (assign,nonatomic) BOOL first;
/** 是否为最后一题 */
@property (assign,nonatomic) BOOL last;

/** 添加题干 */
- (void)addSubjectModel;
/** 添加参考答案 用于回看试题时，显示答案行 */
- (void)addReferAnswer;
// --------------------------以上是新加属性


/// textcode
@property (assign,nonatomic) NSInteger index;

/** 本题的正确答案,用于回看时显示 */
@property (strong,nonatomic) NSString *answer_display;
/** 用户所选 本题答案,用于提交接口 */
@property (strong,nonatomic) NSString *answer;

/** 回答状态
 0 未作答
 1 回答正确
 2 回答错误
 */
@property (assign,nonatomic) ExamSingleRespondState respondState;

/** 是否是回看状态 */
@property (assign,nonatomic) BOOL backLook;

/** 这道题所属的试卷模型 */
@property (strong,nonatomic) OLTkcsModel *testPaper;

/** 记录用户本地选中的答案 */
@property (strong,nonatomic) NSMutableDictionary *userRecord;

@end
