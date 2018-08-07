//
//  OLExamSingleFooterView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

static NSString * const OLExamTurnQuestionNotification = @"OLExamTurnQuestionNotification";
static NSString * const OLExamTurnQuestionNotificationTurnToKey = @"OLExamTurnQuestionNotificationTurnToKey";
static NSString * const OLExamTurnQuestionNotificationIndexKey = @"OLExamTurnQuestionNotificationIndexKey";

typedef NS_ENUM(NSUInteger, ExamTurnTo) {
    ExamTurnToLast,
    ExamTurnToNext,
};

@interface OLExamSingleFooterView : LGBaseView

@property (assign,nonatomic) NSInteger currenIndex;
+ (instancetype)examSingleFooter;

/** 是否是第一题 */
@property (assign,nonatomic) BOOL isFirst;
/** 是否是最后一题 */
@property (assign,nonatomic) BOOL isLast;

@end
