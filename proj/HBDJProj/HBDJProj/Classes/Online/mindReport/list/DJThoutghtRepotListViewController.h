//
//  DJThoutghtRepotListViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 思想汇报，述职述廉列表

#import "LGBaseTableViewController.h"

@interface DJThoutghtRepotListViewController : LGBaseTableViewController

/**
 listType
 思想汇报 -- 6
 述职述廉 -- 7
 */
@property (assign,nonatomic) OnlineModelType listType;

@end
