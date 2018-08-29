//
//  EDJMicroBuildCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectTableViewCell.h"

static NSString * const buildCellNoImg = @"EDJMicroBuildNoImgCell";
static NSString * const buildCellOneImg = @"EDJMicroBuildOneImgCell";
static NSString * const buildCellThreeImg = @"EDJMicroBuildThreeImgCell";

@class EDJMicroBuildModel;

@interface EDJMicroBuildCell : DJUcMyCollectTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView model:(EDJMicroBuildModel *)model;
@property (strong,nonatomic) EDJMicroBuildModel *model;

@end
