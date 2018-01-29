//
//  PayPriceModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface PayPriceModel : BaseModel

@property (assign, nonatomic) NSInteger seqid;           // 系列 id
@property (assign, nonatomic) NSInteger day;             // 租赁天数
@property (strong, nonatomic) NSString *virtualcoinType; // 充值描述
@property (assign, nonatomic) CGFloat price;             // 虚拟币价格
@property (assign, nonatomic) CGFloat virtualcoinSum;    // 充值虚拟币
@property (assign, nonatomic) CGFloat presenterSum;      // 赠送虚拟币
@property (assign, nonatomic) CGFloat domesticPrice;     // 国内支付人民币
@property (assign, nonatomic) CGFloat foreignPrice;      // 国外支付人民币
@property (assign, nonatomic) NSInteger id;              // 价格 id

@end
