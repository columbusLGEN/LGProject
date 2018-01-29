//
//  ShopCarRequest.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "BaseNetRequest.h"

@interface ShopCarRequest : BaseNetRequest

CM_SINGLETON_INTERFACE(ShopCarRequest);
/**
 购物车接口
 */

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
                     completion:(CompleteBlock)completion;

@end
