//
//  HPSearchBuildPoineNewsController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/12.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 搜索结果列表，要闻分表控制器

#import "LGBaseTableViewController.h"
@class DJDataSyncer;

@interface HPSearchBuildPoineNewsController : LGBaseTableViewController
@property (strong,nonatomic) NSString *searchContent;
@property (strong,nonatomic) DJDataSyncer *dataSyncer;

@end
