//
//  OLVoteListModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface OLVoteListModel : LGBaseModel

@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *starttime;
@property (copy,nonatomic) NSString *endtime;
@property (copy,nonatomic) NSString *createdtime;
@property (strong,nonatomic) NSString *source;
/** ??? */
@property (assign,nonatomic) NSInteger modaltype;

/**
 1多选
 0单选
 */
@property (assign,nonatomic) BOOL ismultiselect;

/**
 0 未投票
 1 投票完成
 2 未开始
 3 已经结束
 */
@property (assign,nonatomic) NSInteger votestatus;
/** 活动是否结束 */
@property (assign,nonatomic) BOOL isEnd;

@end
