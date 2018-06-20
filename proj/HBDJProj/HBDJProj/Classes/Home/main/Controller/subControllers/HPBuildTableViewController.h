//
//  HPBuildTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@interface HPBuildTableViewController : LGBaseViewController
@property (strong,nonatomic) NSArray *dataArray;
/** 父控制器 */
@property (strong,nonatomic) UIViewController *superVc;
@property (strong,nonatomic) UITableView *tableView;

@end
