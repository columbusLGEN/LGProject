//
//  OrderRequest.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "OrderRequest.h"

@interface OrderRequest ()

/* 订单数组 */
@property (strong, nonatomic) NSArray *arrOrders;

@end

@implementation OrderRequest

CM_SINGLETON_IMPLEMENTION(OrderRequest)


#pragma mark - 获取订单列表

/**
 获取订单列表
 
 @param page        页数
 @param orderStatus 订单状态(0 未完成 1 待评价 2 完成)
 @param orderType   订单类型(0 购买 1 租赁)
 @param length      每一页数据量
 @param completion  回调
 */
- (void)getOrderListWithPage:(NSInteger)page
                 orderStatus:(ENUM_ZOrderState)orderStatus
                   orderType:(NSString *)orderType
                      length:(NSString *)length
                  completion:(CompleteBlock)completion;
{
    NSDictionary *dic = @{@"params":
                              @{@"length"       : length,
                                @"userId"       : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                @"orderStatus"  : [NSString stringWithFormat:@"%ld", (long)orderStatus],
                                @"orderType"    : orderType,
                                @"page"         : [NSString stringWithFormat:@"%ld", (long)page]},
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/queryOrders"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if ( error )
                                 {
                                     completion(nil,error);
                                 }
                                 else
                                 {
                                     if ([orderType isEqualToString:@"1"]) {
                                         NSArray *series = [SerialModel mj_objectArrayWithKeyValuesArray:responseObject];
                                         completion(series, nil);
                                     }
                                     else {
                                         NSArray *list = [OrderModel mj_objectArrayWithKeyValuesArray:responseObject];
                                         _arrOrders = [NSMutableArray arrayWithArray:list];
                                         completion(_arrOrders, nil);
                                     }
                                 }
                             }];
}

#pragma mark - 获取订单详情

/**
 根据 id 获取订单详情
 
 @param orderId    订单 id
 @param completion  回调
 */
- (void)getOrderInfoWithOrderId:(NSString *)orderId
                     completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":
                              @{@"userId"   : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                @"orderId"  : orderId},
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/queryOrderId"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if ( error ) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 检查订单中的书籍是否已经购买过

/**
 检查订单中的书籍是否已经购买过
 
 @param orderId    订单号
 @param completion 回调
 */
- (void)checkoutPaymentWithOrderId:(NSString *)orderId
                        completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":
                              @{@"userId"   : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                @"orderId"  : orderId},
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/checkoutPayment"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if ( error ) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 创建订单

/**
 创建订单
 
 @param type            类型 0.购买 3.充值
 @param payType         支付类型
 @param totalmoney      总价
 @param fullMinusCost   满减券 id
 @param finalTotalMoney 扣除满减和积分抵扣后的金额 (购买传值)
 @param priceId         选择的价格 id
 @param rechargeMoney   充值虚拟币 (虚拟币不足及充值时使用的)
 @param score           消费积分 (购买传值)
 @param booksId         图书
 @param domorfore       国内外订单
 @param completion      回调
 */
- (void)addOrderWithType:(ENUM_PayPurpose)type
                 payType:(ENUM_PayType)payType
              totalmoney:(CGFloat)totalmoney
           fullMinusCost:(NSString *)fullMinusCost
         finalTotalMoney:(CGFloat)finalTotalMoney
                      id:(NSInteger)priceId
           rechargeMoney:(CGFloat)rechargeMoney
                   score:(NSInteger)score
                 booksId:(NSString *)booksId
               domorfore:(NSInteger)domorfore
              completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":@{@"userId"         : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                      @"type"           : [NSString stringWithFormat:@"%ld", type],
                                      @"payType"        : [NSString stringWithFormat:@"%ld", payType],
                                      @"totalmoney"     : [NSString stringWithFormat:@"%.2f", totalmoney],
                                      @"fullMinusCost"  : fullMinusCost,
                                      @"finalTotalMoney": [NSString stringWithFormat:@"%.2f", finalTotalMoney],
                                      @"id"             : [NSString stringWithFormat:@"%ld", priceId],
                                      @"rechargeMoney"  : [NSString stringWithFormat:@"%.2f", rechargeMoney],
                                      @"score"          : [NSString stringWithFormat:@"%ld", score],
                                      @"booksId"        : booksId,
                                      @"domorfore"      : [NSString stringWithFormat:@"%ld", domorfore]
                                      },
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/addOrder"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 创建系列订单
 
 @param type            类型 1.租赁 2.续租 4.全平台租赁
 @param payType         支付类型
 @param serialId        系列 id
 @param totalmoney      总价
 @param finalTotalMoney 扣除满减和积分抵扣后的金额
 @param priceId         选择的价格 id
 @param rechargeMoney   充值虚拟币
 @param readDay         租赁天数
 @param name            系列名
 @param domorfore       国内外支付
 @param completion      回调
 */
- (void)addSerialOrderWithType:(ENUM_PayPurpose)type
                       payType:(ENUM_PayType)payType
                      serialId:(NSInteger)serialId
                    totalmoney:(CGFloat)totalmoney
               finalTotalMoney:(CGFloat)finalTotalMoney
                            id:(NSInteger)priceId
                 rechargeMoney:(CGFloat)rechargeMoney
                          name:(NSString *)name
                       readDay:(NSInteger)readDay
                     domorfore:(NSInteger)domorfore
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":@{@"userId"         : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                      @"type"           : [NSString stringWithFormat:@"%ld", type],
                                      @"payType"        : [NSString stringWithFormat:@"%ld", payType],
                                      @"serialId"       : serialId > 0 ? [NSString stringWithFormat:@"%ld", serialId] : @"",
                                      @"totalmoney"     : [NSString stringWithFormat:@"%.2f", totalmoney],
                                      @"finalTotalMoney": [NSString stringWithFormat:@"%.2f", finalTotalMoney],
                                      @"id"             : [NSString stringWithFormat:@"%ld", priceId],
                                      @"readDay"        : [NSString stringWithFormat:@"%ld", readDay],
                                      @"name"           : name.length > 0 ? name : @"",
                                      @"rechargeMoney"  : [NSString stringWithFormat:@"%.2f", rechargeMoney],
                                      @"domorfore"      : [NSString stringWithFormat:@"%ld", domorfore]
                                      },
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/addOrder"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 继续支付订单

/**
 继续支付订单
 
 @param orderId         订单 id
 @param type            类型 0.购买 3.充值
 @param payType         支付类型
 @param totalmoney      总价
 @param fullMinusCost   满减券 id
 @param finalTotalMoney 扣除满减和积分抵扣后的金额 (购买传值)
 @param priceId         选择的价格 id
 @param rechargeMoney   充值虚拟币 (虚拟币不足及充值时使用的)
 @param score           消费积分 (购买传值)
 @param booksId         图书
 @param domorfore       国内外支付
 @param completion      回调
 */
- (void)updateOrderWithOrderId:(NSString *)orderId
                      WithType:(ENUM_PayPurpose)type
                       payType:(ENUM_PayType)payType
                    totalmoney:(CGFloat)totalmoney
                 fullMinusCost:(NSString *)fullMinusCost
               finalTotalMoney:(CGFloat)finalTotalMoney
                            id:(NSInteger)priceId
                 rechargeMoney:(CGFloat)rechargeMoney
                         score:(NSInteger)score
                       booksId:(NSString *)booksId
                     domorfore:(NSInteger)domorfore
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":@{@"userId"         : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                      @"type"           : [NSString stringWithFormat:@"%ld", type],
                                      @"payType"        : [NSString stringWithFormat:@"%ld", payType],
                                      @"totalmoney"     : [NSString stringWithFormat:@"%.2f", totalmoney],
                                      @"fullMinusCost"  : fullMinusCost,
                                      @"finalTotalMoney": [NSString stringWithFormat:@"%.2f", finalTotalMoney],
                                      @"id"             : [NSString stringWithFormat:@"%ld", priceId],
                                      @"rechargeMoney"  : [NSString stringWithFormat:@"%.2f", rechargeMoney],
                                      @"score"          : [NSString stringWithFormat:@"%ld", score],
                                      @"booksId"        : booksId,
                                      @"orderId"        : orderId,
                                      @"domorfore"      : [NSString stringWithFormat:@"%ld", domorfore]
                                      },
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/updateOrder"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 修改订单状态为未支付

/**
修改订单状态为未支付

 @param orderId    订单 id
 @param completion  回调
 */
- (void)updateOrderStatusWithOrderId:(NSString *)orderId
                          completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":@{@"userId"     : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                      @"orderId"    : orderId,
                                      @"orderStatus":  [NSString stringWithFormat:@"%ld", ENUM_ZOrderStateObligation],
                                      },
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/updateOrderStatus"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}
#pragma mark - 取消订单

/**
 取消订单
 
 @param orderId     订单 id
 @param completion  回调
 */
- (void)cancelOrderWithOrderId:(NSString *)orderId
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":@{@"userId"     : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                      @"orderId"    : orderId,
                                      @"orderStatus":  [NSString stringWithFormat:@"%ld", ENUM_ZOrderStateCancel],
                                      },
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/updateOrderStatus"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 删除订单

/**
 删除订单
 
 @param orderId    订单 id
 @param completion 回调
 */
- (void)deleteOrderWithOrderId:(NSString *)orderId
                    completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":@{@"userId"     : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                      @"orderId"    : orderId,
                                      @"orderStatus":  [NSString stringWithFormat:@"%ld", ENUM_ZOrderStateDelete],
                                      },
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};

    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/updateOrderStatus"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil,error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 用户订单支付结果

/**
 订单状态
 
 @param orderId    订单 id
 @param type       类型
 @param completion 回调
 */
- (void)getOrderResultWithOrderId:(NSString *)orderId
                             type:(ENUM_PayPurpose)type
                       completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params":@{@"userId"     : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                      @"type"       : [NSString stringWithFormat:@"%ld", type],
                                      @"orderId"    : orderId,
                                      },
                          @"md5": @"654c01acaf40e0ce6d841a552fd3b96c"};
    
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"order/orderPayStatus"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if ( error )
                                 {
                                     completion(nil,error);
                                 }
                                 else
                                 {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 查看用户对订单的评分

/**
 查看用户对订单的评分
 
 @param orderId     订单id
 @param completion  回调
 */
- (void)getOrderScoreWithOrderId:(NSString *)orderId
                      completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"orderId": orderId},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"score/orderScore"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 添加评分

/**
 添加评分
 
 @param orderId       订单id
 @param scores        分数数组（{{"userId":"1","orderDetailId ":"2","bookId":"4","score":"2"}）
 @param commentFinish 评论完成
 @param completion    回调
 */
- (void)addOrderScoreWithOrderId:(NSString *)orderId
                          scores:(NSArray *)scores
                   commentFinish:(NSString *)commentFinish
                      completion:(CompleteBlock)completion
{
    
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"commentFinish": commentFinish,
                                       @"score": scores,
                                       @"orderId": orderId
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"score/addScore"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 查看书籍全部评分

/**
 查看书籍全部评分
 
 @param bookId      书籍id
 @param page        页数
 @param length      每页数据量
 @param completion  回调
 */
- (void)getOrderAllScoresWithBookId:(NSString *)bookId
                               page:(NSString *)page
                             length:(NSString *)length
                         completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"bookId": bookId,
                                       @"page"  : page,
                                       @"length": length,
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"score/selectScore"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 获取支付方式

/**
 获取支付的方式
 
 @param completion 回调
 */
- (void)getPayTypeCompletion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId]},
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"user/selectPayMethod"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 获取支付的价格及类型
 
 @param payPurpose 支付的目的
 @param serialId   系列 id
 @param price      最低支付价格
 @param completion 回调
 */
- (void)getPayPriceWithPayPurpose:(ENUM_PayPurpose)payPurpose
                         serialId:(NSInteger)serialId
                            price:(CGFloat)price
                       completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"serialId": [NSString stringWithFormat:@"%ld", serialId],
                                       @"type"    : [NSString stringWithFormat:@"%ld", payPurpose],
                                       @"price"   : [NSString stringWithFormat:@"%.2f", price > 0 ? price : 0]
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"books/seriesPrice"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

#pragma mark - 获取兑换券兑换的书集列表

/**
 获取兑换券兑换的书集列表 [tickets]
 
 @param page       页码
 @param length     每页条数
 @param completion 回调
 */
- (void)getTicketesWithPage:(NSInteger)page
                     length:(NSInteger)length
                 completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"  : [NSString stringWithFormat:@"%ld", page],
                                       @"length": [NSString stringWithFormat:@"%ld", length],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"cardCouponsInfo/selectReadCouponsBooks"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

/**
 获取兑换券兑换的书的列表 [books]
 
 @param grantbatchId 兑换券批次
 @param page         页码
 @param length       每页条数
 @param completion   回调
 */
- (void)getTicketBooksWithGrantbatchId:(NSInteger)grantbatchId
                                  page:(NSInteger)page
                                length:(NSInteger)length
                            completion:(CompleteBlock)completion
{
    NSDictionary *dic = @{@"params": @{@"userId": [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                       @"page"  : [NSString stringWithFormat:@"%ld", page],
                                       @"length": [NSString stringWithFormat:@"%ld", length],
                                       @"grantbatchId": [NSString stringWithFormat:@"%ld", grantbatchId],
                                       },
                          @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"cardCouponsInfo/selectReadCouponsOwenBooks"
                                parameters:dic
                             completeBlock:^(id responseObject, ErrorModel *error) {
                                 if (error) {
                                     completion(nil, error);
                                 }
                                 else {
                                     completion(responseObject, nil);
                                 }
                             }];
}

@end
