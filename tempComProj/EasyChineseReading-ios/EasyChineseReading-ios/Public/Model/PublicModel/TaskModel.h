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

/* 任务id */
@property (assign, nonatomic) NSInteger taskId;
/* 任务名 */
@property (strong, nonatomic) NSString *taskName;
/* 任务类型 */
@property (assign, nonatomic) NSInteger type;
/* 任务奖励 */
@property (assign, nonatomic) NSInteger award;

@end
