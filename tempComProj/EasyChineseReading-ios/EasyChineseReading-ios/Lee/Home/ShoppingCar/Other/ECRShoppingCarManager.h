//
//  ECRShoppingCarManager.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/9.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECRShoppingCarModel;
typedef void(^shoppingCarSuccessBlock)(NSMutableArray *totalArray,NSMutableArray *tickedArray,CGFloat priceT);
typedef void(^emptyBlock)();
typedef void(^cartCountBlock)(NSInteger count);

@interface ECRShoppingCarManager : NSObject

@property (strong,nonatomic) NSMutableArray<ECRShoppingCarModel *> *totalArray;// 商品数组(可变,方便删减物品)
@property (strong,nonatomic) NSMutableArray<ECRShoppingCarModel *> *tickedArray;// 勾选商品数组
@property (assign,nonatomic) CGFloat totalPrice;// 勾选商品总价

/**
 加载购物车数量

 cartCountBlock 回调数量
 */
+ (void)loadCartCount:(cartCountBlock)countBlock;

// MARK: 管理购物车
- (void)manageShopCarWithDict:(NSDictionary *)dict success:(shoppingCarSuccessBlock)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

/**
 请求购物车数据

 @param anyObjcet nil
 @param success 成功回调
 @param failure 请求失败回调
 @param commenFailure 网络连接错误回调
 */
- (void)loadCartDataWith:(NSObject *)anyObjcet success:(shoppingCarSuccessBlock)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure;

- (void)selectedOrUnselectedWithModel:(ECRShoppingCarModel *)model success:(shoppingCarSuccessBlock)success allsCancel:(emptyBlock)allsCancel;
- (void)clickSelectAllSuccess:(shoppingCarSuccessBlock)success allsCancel:(emptyBlock)allsCancel;
- (void)deleteWithEmpty:(emptyBlock)emptyBlock success:(shoppingCarSuccessBlock)success;
- (void)addWithModel:(ECRShoppingCarModel *)model success:(shoppingCarSuccessBlock)success;
+ (instancetype)sharedInstance;

@end
