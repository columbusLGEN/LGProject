//
//  DJMyCollectViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJMyCollectViewController.h"
#import "LGSegmentBottomView.h"
#import "DJUcMyCollectLessonListController.h"
#import "DJUcMyCollectNewsListController.h"
#import "DJUcMyCollectQAListController.h"
#import "DJUcMyCollectBranchListController.h"
#import "DJUcMyCollectPYQListController.h"

@interface DJMyCollectViewController ()<LGSegmentBottomViewDelegate>

@end

@implementation DJMyCollectViewController

- (void)configUI{
    [super configUI];
    
    self.title = @"我的收藏";
    
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
    /// TODO: 全选 删除操作 仅对当前所在列表生效
    DJUcMyCollectLessonListController *mcllv = self.childViewControllers[0];
    DJUcMyCollectNewsListController *mcnlvc = self.childViewControllers[1];
    DJUcMyCollectQAListController *mcqalvc = self.childViewControllers[2];
    DJUcMyCollectBranchListController *mcblvc = self.childViewControllers[3];
    DJUcMyCollectPYQListController *mcpyqvc = self.childViewControllers[4];
    [mcllv allSelect];
    [mcnlvc allSelect];
    [mcqalvc allSelect];
    [mcblvc allSelect];
    [mcpyqvc allSelect];
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
    /// TODO: 删除
    
}

- (void)changeEditState:(UIButton *)sender{
    /// TODO: 点击删除/取消
    DJUcMyCollectLessonListController *mcllv = self.childViewControllers[0];
    DJUcMyCollectNewsListController *mcnlvc = self.childViewControllers[1];
    DJUcMyCollectQAListController *mcqalvc = self.childViewControllers[2];
    DJUcMyCollectBranchListController *mcblvc = self.childViewControllers[3];
    DJUcMyCollectPYQListController *mcpyqvc = self.childViewControllers[4];
    sender.selected = !sender.isSelected;
    self.isEdit = sender.selected;
    if (sender.isSelected) {
        [mcllv startEdit];
        [mcnlvc startEdit];
        [mcqalvc startEdit];
        [mcblvc startEdit];
        [mcpyqvc startEdit];
    }else{
        [mcllv endEdit];
        [mcnlvc endEdit];
        [mcqalvc endEdit];
        [mcblvc endEdit];
        [mcpyqvc endEdit];
    }
}

- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"微党课",
               LGSegmentItemViewControllerClassKey:@"DJUcMyCollectLessonListController",/// HPSearchLessonController
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"新闻",
               LGSegmentItemViewControllerClassKey:@"DJUcMyCollectNewsListController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"学习问答",
               LGSegmentItemViewControllerClassKey:@"DJUcMyCollectQAListController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"支部动态",
               LGSegmentItemViewControllerClassKey:@"DJUcMyCollectBranchListController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"党员舞台",
               LGSegmentItemViewControllerClassKey:@"DJUcMyCollectPYQListController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}

@end
