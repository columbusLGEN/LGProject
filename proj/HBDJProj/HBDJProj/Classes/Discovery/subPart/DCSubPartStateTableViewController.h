//
//  DCSubPartStateTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// MARK: 支部动态

#import "LGBaseTableViewController.h"
@class DJDataSyncer;

@interface DCSubPartStateTableViewController : LGBaseTableViewController
//@property (assign,nonatomic) BOOL isSearchResult;
@property (assign,nonatomic) NSInteger offset;
@property (strong,nonatomic) DJDataSyncer *dataSyncer;
/** 是否是 搜索的自控制器 */
@property (assign,nonatomic) BOOL isSearchSubvc;
- (void)getData;
@end
