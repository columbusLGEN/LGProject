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
@property (copy,nonatomic) NSString *testTime;
/** 是否已经投票 */
@property (assign,nonatomic) BOOL isVote;
/** 活动是否结束 */
@property (assign,nonatomic) BOOL isEnd;

@end
