//
//  ECRDiscountsOperator.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRDiscountsOperator.h"
#import "ECRVirScoreRateModel.h"
#import "ECRFullminusModel.h"

@interface ECRDiscountsOperator ()


@end

@implementation ECRDiscountsOperator

// 计算总价 参数: 是否使用积分 -- 返回: 1.总价 2.满减卷减去的金额 3.使用了多少积分 & 积分抵扣的金额

/**
 计算总价,满减卷减去的金额 = 原价 - finalPrice - avaPrice;

 @param oriPrice 总价
 @param usedJuan 选中的满减卷数组
 @param rateModel 比例模型
 @param useScore 是否使用积分
 @param completion 计算完成回调
 @param dontUseScoreBlock 不使用积分的回调
 */
+ (void)calPriceWithOriPirce:(CGFloat)oriPrice usedJuan:(NSArray<ECRFullminusModel *> *)usedJuan rateModel:(ECRVirScoreRateModel *)rateModel useScore:(BOOL)useScore completion:(DiscountsOperatorSuccess)completion dontUseScoreBlock:(void(^)())dontUseScoreBlock{
    [[self sharedInstance] calPriceWithOriPirce:oriPrice usedJuan:usedJuan rateModel:rateModel useScore:useScore completion:completion dontUseScoreBlock:dontUseScoreBlock];
}

- (void)calPriceWithOriPirce:(CGFloat)oriPrice usedJuan:(NSArray<ECRFullminusModel *> *)usedJuan rateModel:(ECRVirScoreRateModel *)rateModel useScore:(BOOL)useScore completion:(DiscountsOperatorSuccess)completion dontUseScoreBlock:(void(^)())dontUseScoreBlock{
    __block CGFloat oriPrice_block = oriPrice;
    [usedJuan enumerateObjectsUsingBlock:^(ECRFullminusModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        oriPrice_block -= obj.minusMoney.floatValue;// 减去满减卷的的金额
    }];
    /// 使用了的积分
    NSInteger avaScore = 0;
    /// 使用积分抵扣的虚拟币金额
    NSInteger avaPrice = 0;
    
    if (useScore) {
        /// 勾选了使用积分
        if(!([ECRMultiObject userScore] < rateModel.integralrate.integerValue)) {
            avaPrice = oriPrice_block * (rateModel.integralpercent.integerValue * 0.01);
            if (avaPrice < 1) {
                avaPrice = 0;
            }else{
                // MARK: 计算积分可抵扣的 最高值
                NSInteger maxScore;
                maxScore = oriPrice_block * (rateModel.integralpercent.integerValue * 0.01) * (rateModel.integralrate.integerValue);
                if (maxScore > [ECRMultiObject userScore]) {
                    /// 用户余额不足. 用户余额 去整10
                    avaScore = [ECRMultiObject userScore] - [ECRMultiObject userScore] % 10;
                }else{
                    /// 用户余额足够. maxScore 取整10
                    avaScore = maxScore - maxScore % 10;
                }
            }
        }
    }
    oriPrice_block -= (avaScore / 10);
    if (completion) {
        completion(oriPrice_block, avaScore, avaPrice);
    }
    if (!useScore) {
        if (dontUseScoreBlock) {
            dontUseScoreBlock();
        }
    }
    
}


// 计算可抵扣积分 -> 选择满减卷之后要重新计算,根据满减后的总价
+ (NSInteger)avaScoreWithTickedPrice:(CGFloat)tickedPrice rateModel:(ECRVirScoreRateModel *)model{
    return [[self sharedInstance] avaScoreWithTickedPrice:tickedPrice rateModel:model];
}
- (NSInteger)avaScoreWithTickedPrice:(CGFloat)tickedPrice rateModel:(ECRVirScoreRateModel *)model{
    NSInteger avaScore = 0;
    // 积分抵扣流程:
    /// 0.如果用户的积分余额小于10,不可使用积分进行抵扣
    if ([ECRMultiObject userScore] < model.integralrate.integerValue) {
        avaScore = 0;
    }else{
        /// 可抵扣虚拟币数量
        NSInteger virCanBeDis = tickedPrice * (model.integralpercent.integerValue * 0.01);
        //                NSLog(@"tickedPrice -- %f",tickedPrice);
        //                NSLog(@"最高可抵扣虚拟币 -- %.2f",virCanBeDis);
        if (virCanBeDis < 1) {
            /// 1.计算可抵扣虚拟币的数量,如果小于1,不能使用积分抵扣
            avaScore = 0;
        }else{
            // MARK: 计算积分可抵扣的 最高值
            NSInteger maxScore;
            maxScore = tickedPrice * (model.integralpercent.integerValue * 0.01) * (model.integralrate.integerValue);
            if (maxScore > [ECRMultiObject userScore]) {
                /// 用户余额不足. 用户余额 去整10
                avaScore = [ECRMultiObject userScore] - [ECRMultiObject userScore] % 10;
            }else{
                /// 用户余额足够. maxScore 取整10
                avaScore = maxScore - maxScore % 10;
            }
        }
    }
    return avaScore;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
