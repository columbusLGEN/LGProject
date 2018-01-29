//
//  ShopCarRequest.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ShopCarRequest.h"

@implementation ShopCarRequest

CM_SINGLETON_IMPLEMENTION(ShopCarRequest)

#pragma mark - 管理购物车

/**
 管理购物车
 
 @param bookId      图书id
 @param serialId    系列id
 @param buyType     购买方式（1 购买 2 租赁）
 @param type        操作状态（1 添加购物车 2 在购物车中删除）
 @param orderId     购物车id
 @param readDay     租赁时间
 @param price       价格
 @param completion  回调
 */
- (void)configShopCarWithBookId:(NSString *)bookId
                       serialId:(NSString *)serialId
                        buyType:(NSString *)buyType
                           type:(NSString *)type
                          price:(NSString *)price
                        orderId:(NSString *)orderId
                        readDay:(NSString *)readDay
                     completion:(CompleteBlock)completion
{
    NSDictionary * dic = @{@"params": @{@"userId"   : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                                        @"bookId"   : bookId,
                                        @"serialId" : serialId.length > 0 ? serialId : @"",
                                        @"buyType"  : buyType,
                                        @"price"    : price,
                                        @"id"       : orderId,
                                        @"readDay"  : readDay,
                                        @"type"     : type},
                           @"md5"   : @"654c01acaf40e0ce6d841a552fd3b96c"};
    [ZNetworkRequest requestWithHttpMethod:ENUM_ZHttpRequestMethodPost
                                    strUrl:@"shoppingcart/shoppingCartManagement"
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
