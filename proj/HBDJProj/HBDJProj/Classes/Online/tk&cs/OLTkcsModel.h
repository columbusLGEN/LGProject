//
//  OLTkcsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@class OLExamSingleModel,UCMsgModel;

typedef NS_ENUM(NSUInteger, OLTkcsModelState) {
    /** 进行中 */
    OLTkcsModelStateTesting,
    /** 答题完成 */
    OLTkcsModelStateDone,
    /** 未开始 */
    OLTkcsModelStateNotBegin,
    /** 已经结束 */
    OLTkcsModelStateEnd
};

@interface OLTkcsModel : LGBaseModel
/// ----- 最终提交答案时需要用到
/** 题目id */
@property (assign,nonatomic) NSInteger testid;
/** 这套题中的所有题目（每道题包含了用户的回答情况） */
//@property (strong,nonatomic) NSArray<OLExamSingleModel *> *answers;
/** 耗时， 格式: 00:00:00 */
@property (strong,nonatomic) NSString *timeused_string;
/** 用户耗时，单位:秒 */
@property (assign,nonatomic) NSTimeInterval timeused_timeInterval;
/// -----

/// ----- 需要记录到本地的数据
/** 用户答题的正确数量 */
@property (assign,nonatomic) NSInteger rightCount;
/** 用户答题的错误数量 */
@property (assign,nonatomic) NSInteger wrongCount;
/** 用户答题的正确率 */
@property (assign,nonatomic) NSInteger rightRate;
/** 用户当前答题的索引，用于用户退出后再次进入时，直接跳转到当前试题 */
@property (assign,nonatomic) NSInteger currentIndex;
/// -----

/** 当前试题模型 */
//@property (assign,nonatomic) OLExamSingleModel *currentSingleModel;

/** 试题名称 */
@property (copy,nonatomic) NSString *subjecttitle;
/** 题目数量 */
@property (assign,nonatomic) NSInteger subcount;
/** 答题进度 */
@property (assign,nonatomic) NSInteger progress;



/**
 0 进行中
 1 答题完成
 2 未开始
 3 已经结束
 */
@property (assign,nonatomic) NSInteger teststatus;

/** 状态描述 */
@property (strong,nonatomic) NSString *statusDesc;
/** 状态描述显示颜色 */
@property (strong,nonatomic) UIColor *statusDescColor;
//@property (strong,nonatomic) NSString *createdtime;
@property (strong,nonatomic) NSString *mechanismid;

/** 0:题库 1:测试 */
@property (assign,nonatomic) NSInteger tkcsType;

@property (strong,nonatomic) NSString *separator;

@property (strong,nonatomic) UCMsgModel *msgModel;

@end
