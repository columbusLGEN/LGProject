//
//  LGSegmentViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"
@class LGSegmentView,LGSegmentBottomView;

static NSString *LGSegmentItemNameKey = @"itemNameKey";
static NSString *LGSegmentItemViewControllerClassKey = @"itemViewControllerClassKey";
static NSString *LGSegmentItemViewControllerInitTypeKey = @"LGSegmentItemViewControllerInitTypeKey";

static NSString *LGSegmentVcInitTypeStoryboard = @"LGSegmentVcInitTypeStoryboard";
static NSString *LGSegmentVcInitTypeCode = @"LGSegmentVcInitTypeCode";

@interface LGSegmentViewController : LGBaseViewController

@property (weak,nonatomic) LGSegmentView *segment;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (weak,nonatomic) LGSegmentBottomView *bottom;
@property (strong,nonatomic) NSArray<NSDictionary *> *segmentItems;
@property (assign,nonatomic) CGFloat segmentHeight;
- (void)configUI;
/** 控制segments 到顶部的距离,基类为10,子类自定义自己实现 */
@property (assign,nonatomic) CGFloat segmentTopMargin;

/// 子类重写该方法,以便在切换时获取到当前index
- (void)viewSwitched:(NSInteger)index;

/** 管理控制器的编辑状态 */
@property (assign,nonatomic) BOOL isEdit;

@end
