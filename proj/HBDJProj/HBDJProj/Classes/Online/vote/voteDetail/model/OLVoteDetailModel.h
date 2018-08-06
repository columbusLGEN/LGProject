//
//  OLVoteDetailModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, VoteModelStatus) {
    /** 常规状态，可投票 */
    VoteModelStatusNormal,
    /** 已选 */
    VoteModelStatusSelected,
    /** 已经投票 */
    VoteModelStatusVoted
};

@interface OLVoteDetailModel : LGBaseModel
@property (copy,nonatomic) NSString *content;
/** 选项 */
@property (strong,nonatomic) NSString *options;
/** 该选项投票数 */
@property (assign,nonatomic) NSInteger votecount;
/** 本主题投票总数 */
@property (assign,nonatomic) NSInteger totalCount;
@property (assign,nonatomic) VoteModelStatus localStatus;
/**
 0 未投票
 1 投票完成
 2 未开始
 3 已经结束
 */
//@property (assign,nonatomic) NSInteger status;

/** 当前活动的总票数 */
@property (assign,nonatomic) NSInteger totalVotesCount;
/** 当前选项的票数 */
@property (assign,nonatomic) NSInteger currentVotesCount;

@end
