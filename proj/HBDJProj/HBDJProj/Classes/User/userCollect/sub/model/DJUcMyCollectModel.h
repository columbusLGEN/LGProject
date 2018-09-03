//
//  DJUcMyCollectModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 我的收藏 基类模型

#import "DJDataBaseModel.h"

@interface DJUcMyCollectModel : DJDataBaseModel

/** YES:编辑状态. NO:默认状态 */
@property (assign,nonatomic) BOOL edit;
/** 选中状态 */
@property (assign,nonatomic) BOOL select;

/** 1审核通过 0审核不通过 2审核中 */
@property (assign,nonatomic) NSInteger auditstate;

@end
