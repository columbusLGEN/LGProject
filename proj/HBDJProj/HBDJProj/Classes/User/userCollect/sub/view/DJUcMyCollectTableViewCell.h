//
//  DJUcMyCollectTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 我的收藏 基类cell

#import "LGBaseTableViewCell.h"
@class DJUcMyCollectModel;

@interface DJUcMyCollectTableViewCell : LGBaseTableViewCell
/** 编辑状态下的选中按钮 */
@property (strong,nonatomic) UIButton *seButon;
@property (strong,nonatomic) DJUcMyCollectModel *collectModel;

@end
