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

typedef NS_ENUM(NSUInteger, ExamSingleRespondState) {
    ExamSingleRespondStateDefault,/// 默认状态
    ExamSingleRespondStateCorrect,/// 回答正确
    ExamSingleRespondStateWrong,/// 回答错误
};

@class OLExamSingleLineModel;

@interface OLExamSingleModel : LGBaseModel

//"frontUserTest":[
//
//],
//"creatorid":1,
//"frontSubjectsDetail":[{
//                           "isright":"1",
//                           "creatorid":1,
//                           "options":"作风",
//                           "type":0,
//                           "createdtime":"2018-04-18 13:59:26",
//                           "seqid":198,
//                           "subjectid":"1",
//                           "status":1
//                       }
//                       ],
//"mechanismid":"",
//"score":0,
//"status":1


/** 题干 */
@property (strong,nonatomic) NSString *subject;
/** 1:单选 2:多选 */
@property (assign,nonatomic) NSInteger subjecttype;
/** YES: 表示该题是否选对 */
@property (assign,nonatomic) BOOL isright;
/** 用户选择的选项(单选) */
@property (strong,nonatomic) OLExamSingleLineModel *selectOption;
/** 多选题用户选择的选项(多选) */
@property (strong,nonatomic) NSMutableArray<OLExamSingleLineModel *> *selectOptions;
/** 题目的正确值 */
@property (assign,nonatomic) NSInteger rightValue;
/** 用户所选的值 */
@property (assign,nonatomic) NSInteger selectValue;

@property (strong,nonatomic) NSString *createdtime;
/** 题目选项 */
@property (strong,nonatomic) NSMutableArray<OLExamSingleLineModel *> *frontSubjectsDetail;
@property (strong,nonatomic) NSString *analysis;
@property (strong,nonatomic) NSString *titleid;

/** 添加题干 */
- (void)addSubjectModel;
// --------------------------以上是新加属性


/// textcode
@property (assign,nonatomic) NSInteger index;

/** 本套试题总数 */
@property (assign,nonatomic) NSInteger questioTotalCount;

/** 本题答案 */
@property (assign,nonatomic) ExamSingleAnswer answer;

/** 回答状态
 0 未作答
 1 回答正确
 2 回答错误
 */
@property (assign,nonatomic) ExamSingleRespondState respondState;

/** 是否是回看状态 */
@property (assign,nonatomic) BOOL backLook;

@end
