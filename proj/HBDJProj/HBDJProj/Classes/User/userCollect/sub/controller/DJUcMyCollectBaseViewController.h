//
//  DJUcMyCollectBaseViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 我的收藏 列表基类控制器

#import "LGBaseTableViewController.h"

@interface DJUcMyCollectBaseViewController : LGBaseTableViewController
@property (assign,nonatomic) NSInteger offset;
- (void)startEdit;
- (void)endEdit;
- (void)allSelect;

/** 是否为编辑状态,YES:是. 编辑状态下， 用户可以选择删除  */
@property (assign,nonatomic) BOOL lg_edit;

@end
