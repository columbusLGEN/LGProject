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
@property (weak,nonatomic) UIButton *deButton;

@end

@implementation DJMyCollectViewController

- (void)configUI{
    [super configUI];
    
    self.title = @"我的收藏";
    
    UIButton *deButton = UIButton.new;
    _deButton = deButton;
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
    [self subvcPerformSelector:@selector(allSelect)];
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
    /// TODO: 删除
    
}

- (void)changeEditState:(UIButton *)sender{
    
    sender.selected = !sender.isSelected;
    self.isEdit = sender.selected;
    if (sender.isSelected) {
        [self subvcPerformSelector:@selector(startEdit)];
    }else{
        [self subvcPerformSelector:@selector(endEdit)];
    }
}

- (void)viewSwitched:(NSInteger)index{
    if (self.isEdit) {
        /// 结束编辑
        self.isEdit = !self.isEdit;
        _deButton.selected = NO;
        [self subvcPerformSelector:@selector(endEdit)];
    }
}

- (void)subvcPerformSelector:(SEL)action{
    
    /// 获取当前index
    
    /// 获取当前子控制器
    
    for (DJUcMyCollectBaseViewController *subvc in self.childViewControllers) {
        [subvc performSelector:action];
    }
}

- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"微党课",
               LGSegmentItemViewControllerClassKey:@"DJUcMyCollectLessonListController",///
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
