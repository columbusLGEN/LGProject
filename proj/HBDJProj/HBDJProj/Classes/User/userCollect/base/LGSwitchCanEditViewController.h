//
//  LGSwitchCanEditViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 可以编辑（选择、删除）的 切换控制器

#import "LGSwitchViewController.h"
@class LGSegmentBottomView;

@interface LGSwitchCanEditViewController : LGSwitchViewController
@property (weak,nonatomic) LGSegmentBottomView *allSelecteView;
/** 管理控制器的编辑状态 */
@property (assign,nonatomic) BOOL isEdit;

@end
