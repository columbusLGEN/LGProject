//
//  ECRDiscountsOperator.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/14.
//  Copyright © 2017年 retech. All rights reserved.
//

/// 满减,积分抵扣,价格计算管理者


/**
 计算总价回调

 @param finalPrice 最终需要支付的虚拟币金额
 @param avaScore 使用了的积分
 @param avaPrice 使用积分抵扣了得虚拟币数量
 */
typedef void(^DiscountsOperatorSuccess)(CGFloat finalPrice,NSInteger avaScore, NSInteger avaPrice);

#import <Foundation/Foundation.h>

@class ECRVirScoreRateModel,ECRFullminusModel;

@interface ECRDiscountsOperator : NSObject

/**
 计算总价,满减卷减去的金额 = 原价 - finalPrice - avaPrice;
 
 @param oriPrice 总价
 @param usedJuan 选中的满减卷数组
 @param rateModel 比例模型
 @param useScore 是否使用积分
 @param completion 计算完成回调
 @param dontUseScoreBlock 不使用积分的回调
 */
+ (void)calPriceWithOriPirce:(CGFloat)oriPrice usedJuan:(NSArray<ECRFullminusModel *> *)usedJuan rateModel:(ECRVirScoreRateModel *)rateModel useScore:(BOOL)useScore completion:(DiscountsOperatorSuccess)completion dontUseScoreBlock:(void(^)())dontUseScoreBlock;

/**
  计算可抵扣积分

 @param tickedPrice 总价
 @param model 比例模型
 @return avaScore
 */
+ (NSInteger)avaScoreWithTickedPrice:(CGFloat)tickedPrice rateModel:(ECRVirScoreRateModel *)model;

+ (instancetype)sharedInstance;
@end
