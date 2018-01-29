//
//  UIVCRechargeVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"
#import "ECRVirScoreRateModel.h"

@interface UVirtualCurrencyRechargeVC : ECRBaseViewController

@property (assign, nonatomic) ENUM_PayPurpose payPurpose; // 支付目的
@property (strong, nonatomic) OrderModel *order;          // 订单信息
@property (strong, nonatomic) ECRVirScoreRateModel *scoreRate; // 兑换比例

@end

