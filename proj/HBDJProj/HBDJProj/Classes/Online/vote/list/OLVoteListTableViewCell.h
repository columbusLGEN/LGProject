//
//  OLVoteListTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

static NSString * const cellID = @"OLVoteListTableViewCell";

@class OLVoteListModel;

@interface OLVoteListTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) OLVoteListModel *model;

@end
