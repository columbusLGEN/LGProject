//
//  DJUcMyCollectBaseViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectBaseViewController.h"
#import "DJUcMyCollectModel.h"

@interface DJUcMyCollectBaseViewController ()

@end

@implementation DJUcMyCollectBaseViewController

/// 继承自父类的方法
- (void)startEdit{
    self.lg_edit = YES;
    for (DJUcMyCollectModel *model in self.dataArray) {
        model.edit = YES;
    }
    [self.tableView reloadData];
}
- (void)endEdit{
    self.lg_edit = NO;
    for (DJUcMyCollectModel *model in self.dataArray) {
        model.edit = NO;
    }
    [self.tableView reloadData];
}
- (void)allSelect{
    /// 全选判定条件
    /// 如果全部是选中状态，则取消全部选中状态；否则全部选中
    
    /// 判断是否全部选中
    BOOL allAlreadySelect = YES;
    for (DJUcMyCollectModel *model in self.dataArray) {
        if (!model.select) {
            allAlreadySelect = NO;
            break;
        }
    }
    
    BOOL select;
    if (allAlreadySelect) {
        select = NO;
    }else{
        select = YES;
    }
    
    for (DJUcMyCollectModel *model in self.dataArray) {
        model.select = select;
    }
    [self.tableView reloadData];
}


@end
