//
//  DJMyCollectViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJMyCollectViewController.h"
#import "DJUcMyCollectLessonListController.h"
#import "LGSegmentBottomView.h"

@interface DJMyCollectViewController ()<LGSegmentBottomViewDelegate>

@end

@implementation DJMyCollectViewController

- (void)configUI{
    [super configUI];
    
    UIButton *deButton = UIButton.new;
    [deButton setImage:[UIImage imageNamed:@"home_icon_remove"] forState:UIControlStateNormal];
    [deButton setImage:[UIImage new] forState:UIControlStateSelected];
    [deButton setTitle:@"取消" forState:UIControlStateSelected];
    [deButton setTitleColor:UIColor.EDJGrayscale_11 forState:UIControlStateSelected];
    [deButton addTarget:self action:@selector(changeEditState:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [UIBarButtonItem.alloc initWithCustomView:deButton];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - LGSegmentBottomViewDelegate
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
    /// TODO: 全选
    DJUcMyCollectLessonListController *mcllv = self.childViewControllers[0];
    [mcllv allSelect];
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
    /// TODO: 删除
    
}

- (void)changeEditState:(UIButton *)sender{
    /// TODO: 点击删除/取消
    DJUcMyCollectLessonListController *mcllv = self.childViewControllers[0];
    sender.selected = !sender.isSelected;
    self.isEdit = sender.selected;
    if (sender.isSelected) {
        [mcllv startEdit];
    }else{
        [mcllv endEdit];
    }
}

- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"微党课",
               LGSegmentItemViewControllerClassKey:@"DJUcMyCollectLessonListController",/// HPSearchLessonController
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"新闻",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"学习问答",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"支部动态",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"党员舞台",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}

@end
