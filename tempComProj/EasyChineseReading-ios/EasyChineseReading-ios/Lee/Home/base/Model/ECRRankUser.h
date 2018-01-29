//
//  ECRRankUser.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/16.
//  Copyright © 2017年 retech. All rights reserved.
//

static NSString * const LGPRankUserClickNotification = @"LGPRankUserClickNotification";

#import "ECRRegnUserModel.h"

@interface ECRRankUser : ECRRegnUserModel

@property (assign,nonatomic) NSInteger rank;//
@property (assign,nonatomic) NSInteger readHave;//
/** 模型在原始数组中的索引 */
@property (assign,nonatomic) NSInteger indexInArray;//

@end
