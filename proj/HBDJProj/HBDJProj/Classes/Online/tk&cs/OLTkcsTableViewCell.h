//
//  OLTkcsTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

static NSString * const cellID = @"OLTkcsTableViewCell";

@class OLTkcsModel;

@interface OLTkcsTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) OLTkcsModel *model;

@end
