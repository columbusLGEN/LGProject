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

@end
