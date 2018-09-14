//
//  HPSearchLessonController
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 搜索结果列表党课分表控制器

#import "LGBaseTableViewController.h"
@class DJDataSyncer;
@interface HPSearchLessonController : LGBaseTableViewController
@property (strong,nonatomic) NSString *searchContent;
@property (strong,nonatomic) DJDataSyncer *dataSyncer;

@end
