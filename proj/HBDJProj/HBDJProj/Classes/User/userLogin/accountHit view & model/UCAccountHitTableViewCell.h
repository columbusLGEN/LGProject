//
//  UCAccountHitTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class UCAccountHitModel;

static NSString *cellID = @"UCAccountHitTableViewCell";

@interface UCAccountHitTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) UCAccountHitModel *model;

@end