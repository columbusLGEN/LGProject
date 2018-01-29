//
//  TaskModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface TaskModel : BaseModel

/**
 任务
 */

/** 任务id */
@property (assign, nonatomic) NSInteger taskId;

/** 任务名 */
@property (strong, nonatomic) NSString *taskdescribe;

/**任务详情 id*/
@property (assign, nonatomic) NSInteger taskDetailId;

/** 任务名(en) */
@property (strong, nonatomic) NSString *en_taskdescribe;

/** 任务类型 */
@property (assign, nonatomic) NSInteger tasktype;

/** 奖励值 */
@property (assign, nonatomic) NSInteger taskreward;

/** 任务完成状态 */
@property (assign, nonatomic) ENUM_TaskStatusType status;

/** 任务类型 0 每日 1 一次性 */
@property (assign, nonatomic) NSInteger taskTimes;

/** 活动达成条件数量 */
@property (assign, nonatomic) NSInteger taskreachcount;

/** 活动奖励类型( 1虚拟币 2积分) */
@property (assign, nonatomic) NSInteger taskrewardtype;

// ----------------------

@end
