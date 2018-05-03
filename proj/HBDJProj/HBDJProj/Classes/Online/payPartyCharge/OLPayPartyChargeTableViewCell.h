//
//  OLPayPartyChargeTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class OLPayPartyChargeModel;

static NSString * const cellID = @"OLPayPartyChargeTableViewCell";

@interface OLPayPartyChargeTableViewCell : LGBaseTableViewCell

@property (strong,nonatomic) OLPayPartyChargeModel *model;

@end
