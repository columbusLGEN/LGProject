//
//  TCBIContentCell.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

// 内容简介cell

#import "TCBookInfoCell.h"

static NSString * BICTTcell = @"TCBIContentCell";

NS_ASSUME_NONNULL_BEGIN

@interface TCBIContentCell : TCBookInfoCell
@property (strong,nonatomic) UIButton *showAll;

@end

NS_ASSUME_NONNULL_END
