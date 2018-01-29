//
//  VirtualCurrencyModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/26.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface VirtualCurrencyModel : BaseModel
/**
 虚拟币
 */

/** 来源或去向 */
@property (strong, nonatomic) NSString *name;
/** 时间 */
@property (strong, nonatomic) NSString *time;
/** 虚拟币 */
@property (strong, nonatomic) NSString *money;
/** 类型 */
@property (assign, nonatomic) ENUM_IntegralType type;

@end
