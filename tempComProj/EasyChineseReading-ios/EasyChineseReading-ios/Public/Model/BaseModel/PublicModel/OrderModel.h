//
//  OrderModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface BizContent : NSObject

// NOTE: (非必填项)商品描述
@property (copy, nonatomic) NSString *body;

// NOTE: 商品的标题/交易标题/订单标题/订单关键字等。
@property (copy, nonatomic) NSString *subject;

// NOTE: 商户网站唯一订单号
@property (copy, nonatomic) NSString *out_trade_no;

// NOTE: 该笔订单允许的最晚付款时间，逾期将关闭交易。
//       取值范围：1m～15d m-分钟，h-小时，d-天，1c-当天(1c-当天的情况下，无论交易何时创建，都在0点关闭)
//       该参数数值不接受小数点， 如1.5h，可转换为90m。
@property (copy, nonatomic) NSString *timeout_express;

// NOTE: 订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
@property (copy, nonatomic) NSString *total_amount;

// NOTE: 收款支付宝用户ID。 如果该值为空，则默认为商户签约账号对应的支付宝用户ID (如 2088102147948060)
@property (copy, nonatomic) NSString *seller_id;

// NOTE: 销售产品码，商家和支付宝签约的产品码 (如 QUICK_MSECURITY_PAY)
@property (copy, nonatomic) NSString *product_code;

@end

@interface OrderModel : NSObject

/**
 订单
 */

/** 订单编号 */
@property (strong, nonatomic) NSString *orderId;
/** 订单时间 */
@property (strong, nonatomic) NSString *date;
/** 图书 */
@property (strong, nonatomic) NSArray *books;/// 
/** 订单状态 */
@property (assign, nonatomic) ENUM_ZOrderState orderStatus;
/** 全部评论完成 0 未全部评论 */
@property (assign, nonatomic) NSInteger commentFinish;
/** 订单类型 */
@property (assign, nonatomic) ENUM_PayPurpose orderType;
/** 支付类型 */
@property (assign, nonatomic) ENUM_PayType payType;
/** 订单详情Id */
@property (assign, nonatomic) NSString *orderDetailId;

/** 系列 id */
@property (assign, nonatomic) NSInteger serialId;
/** 租阅时长 */
@property (assign, nonatomic) NSInteger readDay;
/** 系列名 */
@property (strong, nonatomic) NSString *name;

/** 充值金额 */
@property (assign, nonatomic) CGFloat rechargeMoney;
/** 总价 */
@property (assign, nonatomic) CGFloat totalmoney;///
/** 图书单价 */
@property (assign, nonatomic) CGFloat price;
/** 使用的满减券 id */
@property (strong, nonatomic) NSArray *fullMinusCost;///
/** 扣除满减和积分抵扣后的金额 */
@property (assign, nonatomic) CGFloat finalTotalMoney;///
/** 消费积分 */
@property (assign, nonatomic) NSInteger score;///

/** 选择充值的 id */
@property (assign, nonatomic) NSInteger priceId;
/** 是否租阅全平台 */
@property (assign, nonatomic) BOOL allbooks;

/** 是否显示全部书籍 */
@property (assign, nonatomic) BOOL showAllBook;
/** 全平台包月截止时间 */
@property (strong, nonatomic) NSString *endTime;
/** 选择充值数额的 id */
@property (assign, nonatomic) NSInteger rechargeId;


// ---- 支付宝返回订单数据

// NOTE: 支付宝分配给开发者的应用ID(如2014072300007148)
@property (copy, nonatomic) NSString *app_id;

// NOTE: 支付接口名称
@property (copy, nonatomic) NSString *method;

// NOTE: (非必填项)仅支持JSON
@property (copy, nonatomic) NSString *format;

// NOTE: (非必填项)HTTP/HTTPS开头字符串
@property (copy, nonatomic) NSString *return_url;

// NOTE: 参数编码格式，如utf-8,gbk,gb2312等
@property (copy, nonatomic) NSString *charset;

// NOTE: 请求发送的时间，格式"yyyy-MM-dd HH:mm:ss"
@property (copy, nonatomic) NSString *timestamp;

// NOTE: 请求调用的接口版本，固定为：1.0
@property (copy, nonatomic) NSString *version;

// NOTE: (非必填项)支付宝服务器主动通知商户服务器里指定的页面http路径
@property (copy, nonatomic) NSString *notify_url;

// NOTE: (非必填项)商户授权令牌，通过该令牌来帮助商户发起请求，完成业务(如201510BBaabdb44d8fd04607abf8d5931ec75D84)
@property (copy, nonatomic) NSString *app_auth_token;

// NOTE: 具体业务请求数据
@property (strong, nonatomic) BizContent *biz_content;

// NOTE: 签名类型
@property (copy, nonatomic) NSString *sign_type;

/**
 *  获取订单信息串
 *
 *  @param bEncoded       订单信息串中的各个value是否encode
 *                        非encode订单信息串，用于生成签名
 *                        encode订单信息串 + 签名，用于最终的支付请求订单信息串
 */
- (NSString *)orderInfoEncoded:(BOOL)bEncoded;


// ------------------- 9.19 备注 没用了
/* 状态 */
//@property (assign, nonatomic) ENUM_ZOrderState paystatus;

@end
