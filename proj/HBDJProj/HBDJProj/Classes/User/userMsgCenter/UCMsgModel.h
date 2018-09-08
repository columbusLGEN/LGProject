//
//  UCMsgModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, UCMsgModelResourceType) {
    /** 自定义消息 */
    UCMsgModelResourceTypeCustom = 0,
    /** 党建要闻 */
    UCMsgModelResourceTypeNews = 1,
    /** 学习问答 */
    UCMsgModelResourceTypeQA = 2,
    /** 支部动态 */
    UCMsgModelResourceTypeBranch = 3,
    /** 党员舞台 */
    UCMsgModelResourceTypePYQ = 4,
    /** 述职报告 */
    UCMsgModelResourceTypeSpeech = 5,
    /** 在线投票 */
    UCMsgModelResourceTypeVote = 6,
    /** 知识测试 */
    UCMsgModelResourceTypeTest = 7,
    /** 个人积分 */
    UCMsgModelResourceTypeScore = 8
    
};

typedef NS_ENUM(NSUInteger, UCMsgVoteTestStatus) {
    /** 进行中 */
    UCMsgVoteTestStatusING,
    /** 答题完成 */
    UCMsgVoteTestStatusDone,
    /** 未开始 */
    UCMsgVoteTestStatusNotBegin,
    /** 已经结束 */
    UCMsgVoteTestStatusEnd
};

@interface UCMsgModel : LGBaseModel
@property (assign,nonatomic) BOOL isEdit;
@property (assign,nonatomic) BOOL select;

/** 消息内容 */
@property (strong,nonatomic) NSString *content;
/** 是否已读 */
@property (assign,nonatomic) BOOL isread;
/** 0自定义消息 1党建要闻 2学习问答 3支部动态 4党员舞台 5述职汇报 6在线投票 7知识测试 8个人积分 */
@property (assign,nonatomic) UCMsgModelResourceType noticetype;
/** 0进行中 1答题完成 2未开始 3已经结束 */
@property (assign,nonatomic) UCMsgVoteTestStatus votestestsstatus;
/** 测试/投票 截止时间 */
@property (strong,nonatomic) NSString *endtime;
/** 投票需要用的 starttime */
@property (strong,nonatomic) NSString *starttime;
/** 投票需要用的 title */
@property (strong,nonatomic) NSString *title;
/** 投票的单选多选 */
@property (assign,nonatomic) BOOL ismultiselect;
/** 源id */
@property (assign,nonatomic) NSInteger resourceid;

@property (assign,nonatomic) BOOL showAll;
@property (strong,nonatomic) NSIndexPath *indexPath;

//消息数据的 createdtime 是时间戳

@end
