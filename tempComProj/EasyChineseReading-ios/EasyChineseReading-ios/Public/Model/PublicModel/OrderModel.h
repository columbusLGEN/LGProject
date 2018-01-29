//
//  OrderModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel

/**
 订单
 */

/* 订单号 */
@property (strong, nonatomic) NSString *orderNumber;
/* 状态 */
@property (assign, nonatomic) ENUM_ZOrderState state;
/* 价格 */
@property (strong, nonatomic) NSString *money;
/* 订单时间 */
@property (strong, nonatomic) NSString *date;

/* 图书 */
@property (strong, nonatomic) NSArray *books;

@end
