//
//  ECRPayDoneController.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/10.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface ECRPayDoneController : ECRBaseViewController

/// 用户需要支付的虚拟币金额
@property (assign,nonatomic) CGFloat finalPrice;//

/// 订单id
@property (assign,nonatomic) NSInteger orderId;/// 订单id

@end
