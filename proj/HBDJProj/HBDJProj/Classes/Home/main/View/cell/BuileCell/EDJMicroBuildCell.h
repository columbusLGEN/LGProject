//
//  EDJMicroBuildCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class EDJMicroBuildModel;

@interface EDJMicroBuildCell : LGBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(EDJMicroBuildModel *)model;
@end
