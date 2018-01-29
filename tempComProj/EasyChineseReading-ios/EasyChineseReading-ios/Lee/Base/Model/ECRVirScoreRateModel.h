//
//  ECRVirScoreRateModel.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/1.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECRVirScoreRateModel : NSObject

/** 积分与虚拟币兑换比例 */
@property (strong,nonatomic) NSNumber *integralrate;
/** 可使用积分抵扣比例 */
@property (strong,nonatomic) NSNumber *integralpercent;
/** 国外人民币比例 */
@property (strong,nonatomic) NSNumber *foreignrate;
/** 国内人民币比例 */
@property (strong,nonatomic) NSNumber *domesticrate;

@end
