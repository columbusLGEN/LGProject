//
//  DCSubPartStateDetailViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 支部动态详情页面

#import "LGBaseViewController.h"
@class DCSubPartStateModel,DJDataSyncer;

@interface DCSubPartStateDetailViewController : LGBaseViewController
@property (strong,nonatomic) DCSubPartStateModel *model;
@property (assign,nonatomic) BOOL showCommentView;
@property (strong,nonatomic) DJDataSyncer *dataSyncer;
/** 是否是 搜索的自控制器 */
@property (assign,nonatomic) BOOL isSearchSubvc;
/// 给子类继承
- (void)dataSettings;

@end
