//
//  UCSettingTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class UCSettingModel;

@protocol UCSettingTableViewCellDelegate <NSObject>
- (void)stCellClickSwitchWithModel:(UCSettingModel *)model sender:(UISwitch *)sender;

@end

@interface UCSettingTableViewCell : LGBaseTableViewCell
@property (strong,nonatomic) UCSettingModel *model;
@property (weak,nonatomic) id<UCSettingTableViewCellDelegate> delegate;

@end
