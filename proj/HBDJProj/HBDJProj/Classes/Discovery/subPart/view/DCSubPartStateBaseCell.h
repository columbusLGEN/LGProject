//
//  DCSubPartStateBaseCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class DCSubPartStateModel;

static NSString * const withoutImgCell = @"DCSubPartStateWithoutImgCell";
static NSString * const oneImgCell = @"DCSubPartStateOneImgCell";
static NSString * const threeImgCell = @"DCSubPartStateThreeImgCell";

@interface DCSubPartStateBaseCell : LGBaseTableViewCell
@property (strong,nonatomic) DCSubPartStateModel *model;

@end
