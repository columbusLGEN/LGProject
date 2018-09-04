//
//  DJThoutghtRepotListModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 思想汇报 & 述职述廉 列表模型

//#import "LGBaseModel.h"
#import "DJThemeMeetingsModel.h"

@interface DJThoutghtRepotListModel : DJThemeMeetingsModel

/** YES:编辑状态. NO:默认状态 */
@property (assign,nonatomic) BOOL edit;
/** 选中状态 */
@property (assign,nonatomic) BOOL select;

/** 0: 未通过 1: 通过 */
@property (assign,nonatomic) NSInteger auditstate;

@end
