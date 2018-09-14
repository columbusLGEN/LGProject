//
//  DCSubStageTableviewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 党员舞台列表 (朋友圈)

#import "LGBaseTableViewController.h"
@class DJDataSyncer;

@interface DCSubStageTableviewController : LGBaseTableViewController
@property (assign,nonatomic) NSInteger offset;
@property (strong,nonatomic) DJDataSyncer *dataSyncer;
- (void)getData;
/** 是否是 搜索的自控制器 */
@property (assign,nonatomic) BOOL isSearchSubvc;

@end
