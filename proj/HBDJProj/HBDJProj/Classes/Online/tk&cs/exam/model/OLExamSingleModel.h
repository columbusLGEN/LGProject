//
//  OLExamModel.h
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
@property (strong,nonatomic) NSArray<OLExamSingleLineModel *> *contents;

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
