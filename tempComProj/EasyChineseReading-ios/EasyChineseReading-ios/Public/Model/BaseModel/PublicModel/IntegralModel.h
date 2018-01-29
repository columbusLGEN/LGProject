//
//  IntegralModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/26.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface IntegralModel : BaseModel

/**
 积分模型
 */

/** 来源或去向 */
@property (strong, nonatomic) NSString *soure;
@property (strong, nonatomic) NSString *en_soure;
/** 时间 */
@property (strong, nonatomic) NSString *time;
/** 积分 */
@property (strong, nonatomic) NSString *score;
/** 类型 */
@property (assign, nonatomic) ENUM_IntegralType type;

@end
