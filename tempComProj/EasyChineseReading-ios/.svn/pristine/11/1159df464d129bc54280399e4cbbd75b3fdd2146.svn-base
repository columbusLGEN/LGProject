//
//  AliPayResponseModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/1.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseModel.h"

@interface AliPayResponseModel : BaseModel

/** 返回码 */
@property (strong, nonatomic) NSString *code;
/** 返回码描述，信息来自于code返回结果的描述 */
@property (strong, nonatomic) NSString *msg;
/** 明细返回码 */
@property (strong, nonatomic) NSString *sub_code;
/** 明细返回码描述 */
@property (strong, nonatomic) NSString *sub_msg;
/** 支付宝分配给开发者的应用Id。 */
@property (strong, nonatomic) NSString *app_id;
/** 商户网站唯一订单号 */
@property (strong, nonatomic) NSString *out_trade_no;
/** 该交易在支付宝系统中的交易流水号。最长64位。 */
@property (strong, nonatomic) NSString *trade_no;
/** 该笔订单的资金总额，单位为RMB-Yuan。取值范围为[0.01,100000000.00]，精确到小数点后两位。 */
@property (strong, nonatomic) NSString *total_amount;
/** 收款支付宝账号对应的支付宝唯一用户号。以2088开头的纯16位数字 */
@property (strong, nonatomic) NSString *seller_id;
/** 编码格式 */
@property (strong, nonatomic) NSString *charset;
/** 时间 */
@property (strong, nonatomic) NSString *timestamp;

@end



