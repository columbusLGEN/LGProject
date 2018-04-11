//
//  EDJMicroPartyLessonCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class EDJMicroBuildModel;

@interface EDJMicroPartyLessonCell : LGBaseTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView model:(EDJMicroBuildModel *)model;

@end
