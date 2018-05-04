//
//  OLVoteDetailModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, VoteModelStatus) {
    VoteModelStatusNormal,
    VoteModelStatusSelected,
    VoteModelStatusVoted
};

@interface OLVoteDetailModel : LGBaseModel
@property (copy,nonatomic) NSString *content;
@property (assign,nonatomic) VoteModelStatus status;
/** 当前活动的总票数 */
@property (assign,nonatomic) NSInteger totalVotesCount;
/** 当前选项的票数 */
@property (assign,nonatomic) NSInteger currentVotesCount;

@end