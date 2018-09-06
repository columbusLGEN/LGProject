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
#import "DJUcMyCollectModel.h"

@interface DJMyCollectViewController ()<
LGSegmentBottomViewDelegate,
DJUCSubListDelegate>
@property (weak,nonatomic) UIButton *deButton;

@end

@implementation DJMyCollectViewController{
    NSMutableArray *selectDeleteModelArray;
    NSInteger currentvcIndex;
}

- (void)configUI{
    [super configUI];
    
    self.title = @"我的收藏";
    
    currentvcIndex = 0;
    
    UIButton *deButton = UIButton.new;
    _deButton = deButton;
    [deButton setImage:[UIImage imageNamed:@"home_icon_remove"] forState:UIControlStateNormal];
    [deButton setImage:[UIImage new] forState:UIControlStateSelected];
    [deButton setTitle:@"取消" forState:UIControlStateSelected];
    [deButton setTitleColor:UIColor.EDJGrayscale_11 forState:UIControlStateSelected];
    [deButton addTarget:self action:@selector(changeEditState:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [UIBarButtonItem.alloc initWithCustomView:deButton];
    self.navigationItem.rightBarButtonItem = right;
    
    for (DJUcMyCollectBaseViewController *subvc in self.childViewControllers) {
        subvc.delegate = self;
    }
}

#pragma mark - LGSegmentBottomViewDelegate
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
    /// 全选 删除操作 仅对当前所在列表生效
    [self subvcPerformSelector:@selector(allSelect)];
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0; i < selectDeleteModelArray.count; i++) {
        DJUcMyCollectModel *model = selectDeleteModelArray[i];
        NSString *coidStr = [NSString stringWithFormat:@"%ld",model.collectionid];
        [arrmu addObject:coidStr];
    }
    NSString *coid_s = [arrmu componentsJoinedByString:@","];
    /// TODO: 如果需要在删除前 让用户确认，再次添加 alert
    
    if (coid_s == nil || [coid_s isEqualToString:@""]) {
        return;
    }
    
    /// MARK: 发送批量删除收藏请求
    [DJUserNetworkManager.sharedInstance frontUserCollections_deleteBatchWithCoids:coid_s success:^(id responseObj) {
       /// 当前控制器刷新数据
        [self exitEditState];
        [self.currentSubvc subvcReloadData];
    } failure:^(id failureObj) {
        [self presentFailureTips:op_failure_notice];
    }];
}

#pragma mark - DJUCSubListDelegate
- (void)ucmcCellClickWhenEdit:(DJUcMyCollectModel *)model modelArrayCount:(NSInteger)count{
    if (model.select) {
        /// 添加
        [selectDeleteModelArray addObject:model];
    }else{
        /// 删除
        [selectDeleteModelArray removeObject:model];
    }
    if (selectDeleteModelArray.count == count) {
        self.allSelecteView.asbState = YES;
    }else{
        self.allSelecteView.asbState = NO;
    }
}
- (void)ucmcAllSelectClickWhenEdit:(NSArray<DJUcMyCollectModel *> *)array{
    if (array) {
        selectDeleteModelArray = [NSMutableArray arrayWithArray:array];
    }else{
        [selectDeleteModelArray removeAllObjects];
    }
    
}

- (void)changeEditState:(UIButton *)sender{
    if (!selectDeleteModelArray) {
        selectDeleteModelArray = NSMutableArray.new;
    }
    self.isEdit = !self.isEdit;
    sender.selected = self.isEdit;
    if (sender.isSelected) {
        [self subvcPerformSelector:@selector(startEdit)];
    }else{
        [self exitEditState];
    }
}

- (void)viewSwitched:(NSInteger)index{
    if (self.isEdit) {
        /// 结束编辑
        [self exitEditState];
    }
    currentvcIndex = index;
    
}
/// MARK: 退出编辑状态
- (void)exitEditState{
    self.isEdit = NO;
    _deButton.selected = NO;
    self.allSelecteView.asbState = NO;
    [self subvcPerformSelector:@selector(endEdit)];
}

- (void)subvcPerformSelector:(SEL)action{
    /// 获取当前子控制器
    [self.currentSubvc performSelector:action];

}

- (DJUcMyCollectBaseViewController *)currentSubvc{
    return self.childViewControllers[currentvcIndex];
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
