//
//  EDJLevelInfoModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJLevelInfoModel : LGBaseModel

/** 加分项目名称 */
@property (strong,nonatomic) NSString *item;
/** 条件的值 */
@property (strong,nonatomic) NSString *integraldimension;
/** 条件的单位 1:次,2:分钟 */
@property (assign,nonatomic) NSInteger integraltype;
/** 条件的单位字符串，次 或 分钟 */
@property (strong,nonatomic) NSString *unit;
/** 满足一次条件的 奖励 */
@property (strong,nonatomic) NSString *singleintegral;
/** 奖励上限 */
@property (strong,nonatomic) NSString *total;

/// 今日加分
/** 今日完成此任务获取的积分 */
@property (assign,nonatomic) NSInteger getintegral;
/** 完成次数，分钟 */
@property (assign,nonatomic) NSInteger completenum;

@end
