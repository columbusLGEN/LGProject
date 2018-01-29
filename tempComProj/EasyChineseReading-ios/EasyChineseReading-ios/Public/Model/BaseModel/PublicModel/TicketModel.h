//
//  TicketModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/23.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface TicketModel : BaseModel

/** 满减券Id */
@property (assign, nonatomic) NSInteger seqid;
/** 满减开始时间 */
@property (strong, nonatomic) NSString *starttime;
/** 满减结束时间 */
@property (strong, nonatomic) NSString *endtime;
/** 状态 */
@property (assign, nonatomic) ENUM_TicketStatus status;
/** 满减类型 */
@property (strong, nonatomic) NSString *fullminusType;
/** 减少金额 */
@property (assign, nonatomic) NSInteger minusMoney;
/** 总数量 */
@property (assign, nonatomic) NSInteger totalNum;
/** 已经领取 */
@property (assign, nonatomic) NSInteger receiveNum;
/** 活动标题 */
@property (strong, nonatomic) NSString *activityTitle;
/** 活动 id */
@property (assign, nonatomic) NSInteger activityId;
/** 创建人 id */
@property (assign, nonatomic) NSInteger creatorid;
/** 创建时间 */
@property (strong, nonatomic) NSString *createdtime;
/** 活动名称 */
@property (strong, nonatomic) NSString *activityName;
/** 满足条件 */
@property (assign, nonatomic) CGFloat fullMoney;
/** 满减券描述 */
@property (strong, nonatomic) NSString *memo;
@property (strong, nonatomic) NSString *en_memo; 

@end

