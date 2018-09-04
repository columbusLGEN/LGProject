//
//  DJLevelHomeModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"
@class EDJLevelInfoModel,EDJLevelInsModel;

@interface DJLevelHomeModel : LGBaseModel

/** 用户总积分 */
@property (assign,nonatomic) NSInteger allintegral;
/** 等级名 例如 先锋党员一级 */
@property (strong,nonatomic) NSString *gradename;
/** 升级所需积分 */
@property (assign,nonatomic) NSInteger leaveupneed;
/** 获取积分规则列表，以及 今日加分列表 */
@property (strong,nonatomic) NSArray<EDJLevelInfoModel *> *frontIntegral;
/** 等级介绍,等级列表 */
@property (strong,nonatomic) NSArray<EDJLevelInsModel *> *frontIntegralGrade;

/** 等级 */
@property (assign,nonatomic) NSInteger grade;
/** 今日获取积分 */
@property (assign,nonatomic) NSInteger todaygetintegral;

@end
