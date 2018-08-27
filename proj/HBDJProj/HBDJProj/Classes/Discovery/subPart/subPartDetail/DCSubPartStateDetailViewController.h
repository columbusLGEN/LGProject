//
//  DCSubPartStateDetailViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 支部动态详情页面

#import "LGBaseViewController.h"
@class DCSubPartStateModel;

@interface DCSubPartStateDetailViewController : LGBaseViewController
@property (strong,nonatomic) DCSubPartStateModel *model;
@property (assign,nonatomic) BOOL showCommentView;

@end
