//
//  DCStateCommentsTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 详情页 评论 cell

#import "LGBaseTableViewCell.h"
@class DCStateCommentsModel;
static NSString *cellID = @"DCStateCommentsTableViewCell";

@interface DCStateCommentsTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) DCStateCommentsModel *model;

@end
