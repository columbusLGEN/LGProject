//
//  UCMsgTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class UCMsgModel;
@interface UCMsgTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) UCMsgModel *model;
@end
