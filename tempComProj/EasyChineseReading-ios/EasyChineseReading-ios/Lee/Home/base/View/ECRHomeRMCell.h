//
//  ECRHomeRMCell.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

// 阅读达人榜cell

#import "ECRBaseTableViewCell.h"
@class ECRRankUser;
@interface ECRHomeRMCell : ECRBaseTableViewCell
@property (strong,nonatomic) ECRRankUser *model;//
@property (assign,nonatomic) CGFloat cellHeight;//
@end
