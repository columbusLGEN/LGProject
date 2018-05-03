//
//  OLPayPartyChargeModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface OLPayPartyChargeModel : LGBaseModel
@property (copy,nonatomic) NSString *testTime;
/** YES: 已经缴纳 */
@property (assign,nonatomic) BOOL isPay;

@end
