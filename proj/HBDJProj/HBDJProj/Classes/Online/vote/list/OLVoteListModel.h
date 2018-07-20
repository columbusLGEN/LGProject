//
//  OLVoteListModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface OLVoteListModel : LGBaseModel

//{"seqid":1,"title":"习近平在庆祝中国人民解放军建军90周年阅兵时
//    的讲话","cover":"group1/M00/00/0C/CgoKBFq5uYaAMPPoAAFIlkwhY8w124.jpg","source":"
//    习近平","modaltype":"2","classid":""}

@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *testTime;
@property (strong,nonatomic) NSString *source;
/** ??? */
@property (assign,nonatomic) NSInteger modaltype;

//TODO: 缺 time

/** 是否已经投票 */
@property (assign,nonatomic) BOOL isVote;
/** 活动是否结束 */
@property (assign,nonatomic) BOOL isEnd;

@end
