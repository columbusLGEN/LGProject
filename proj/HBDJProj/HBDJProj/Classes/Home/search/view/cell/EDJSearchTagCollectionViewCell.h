//
//  EDJSearchTagCollectionViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseCollectionViewCell.h"
@class EDJSearchTagModel;

static NSString * const historyCell = @"EDJSearchTagHistoryCell";
static NSString * const hotCell = @"EDJSearchTagHotCell";

@interface EDJSearchTagCollectionViewCell : LGBaseCollectionViewCell

+ (NSString *)cellIdWithIndexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) EDJSearchTagModel *model;

@end
