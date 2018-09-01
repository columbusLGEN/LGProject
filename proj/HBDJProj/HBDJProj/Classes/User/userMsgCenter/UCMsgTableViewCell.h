//
//  UCMsgTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

static NSString * const msgCell = @"UCMsgTableViewCell";
static NSString * const msgEditCell = @"UCMsgEditTableViewCell";

@class UCMsgModel;

@protocol UCMsgTableViewCellDelegate <NSObject>
- (void)ucmsgCellShowAllWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface UCMsgTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) UCMsgModel *model;
@property (weak,nonatomic) id<UCMsgTableViewCellDelegate> delegate;

@end
