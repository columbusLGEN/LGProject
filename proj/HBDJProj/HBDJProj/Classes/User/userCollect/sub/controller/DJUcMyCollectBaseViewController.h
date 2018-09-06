//
//  DJUcMyCollectBaseViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 我的收藏 列表基类控制器

#import "LGBaseTableViewController.h"
@class DJUcMyCollectModel,DJThoutghtRepotListModel;

@protocol DJUCSubListDelegate <NSObject>
@optional
- (void)ucmcCellClickWhenEdit:(DJUcMyCollectModel *)model modelArrayCount:(NSInteger)count;
- (void)ucmcAllSelectClickWhenEdit:(NSArray<DJUcMyCollectModel *> *)array;

- (void)ucmp_mindCellClickWhenEdit:(DJThoutghtRepotListModel *)model modelArrayCount:(NSInteger)count;
- (void)ucmp_mindAllSelectClickWhenEdit:(NSArray<DJThoutghtRepotListModel *> *)array;

@end

@interface DJUcMyCollectBaseViewController : LGBaseTableViewController
@property (assign,nonatomic) NSInteger offset;
- (void)startEdit;
- (void)endEdit;
- (void)allSelect;

/** 是否为编辑状态,YES:是. 编辑状态下， 用户可以选择删除  */
@property (assign,nonatomic) BOOL lg_edit;

@property (assign,nonatomic) BOOL isAllSelect;
@property (weak,nonatomic) id<DJUCSubListDelegate> delegate;
- (void)subvcReloadData;

@end
