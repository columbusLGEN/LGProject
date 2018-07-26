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
//"subject":"领导干部的（），不仅关系自己的家庭，而且关系党风政风",
//"titleid":"1",
//"creatorid":1,
//"analysis":"",
//"frontSubjectsDetail":[
//                       {
//                           "isright":"1",
//                           "creatorid":1,
//                           "options":"作风",
//                           "type":0,
//                           "createdtime":"2018-04-18 13:59:26",
//                           "seqid":198,
//                           "subjectid":"1",
//                           "status":1
//                       },
//                       {
//                           "isright":"1",
//                           "creatorid":1,
//                           "options":"家风",
//                           "type":0,
//                           "createdtime":"2018-04-18 13:59:26",
//                           "seqid":199,
//                           "subjectid":"1",
//                           "status":1
//                       },
//                       {
//                           "isright":"",
//                           "creatorid":1,
//                           "options":"家庭意识",
//                           "type":0,
//                           "createdtime":"2018-04-18 13:59:26",
//                           "seqid":200,
//                           "subjectid":"1",
//                           "status":1
//                       },
//                       {
//                           "isright":"",
//                           "creatorid":1,
//                           "options":"裙带意识",
//                           "type":0,
//                           "createdtime":"2018-04-18 13:59:26",
//                           "seqid":201,
//                           "subjectid":"1",
//                           "status":1
//                       }
//                       ],
//"mechanismid":"",
//"createdtime":"2018-03-21 15:34:54",
//"score":0,
//"subjecttype":"2",
//"seqid":1,
//"status":1

/**
 需要，但是返回值没有的数据
    1.本题的正确答案

 */


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
