//
//  UCUploadHomePageViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadHomePageViewController.h"
#import "UCUploadTransitionView.h"
#import "LGSegmentBottomView.h"
#import "DJUcMyUploadPYQListController.h"
#import "DJUcMyUploadMindReportListController.h"
#import "DJUcMyUploadCheapSpeechListController.h"
#import "UCUploadPyqViewController.h"
#import "DJUploadMindReportController.h"
#import "DJUcMyCollectModel.h"
#import "DJThoutghtRepotListModel.h"

@interface UCUploadHomePageViewController ()<
UCUploadTransitionViewDelegate,
LGSegmentBottomViewDelegate,
DJUCSubListDelegate
>
/** 是否是编辑状态，默认为no */
@property (assign,nonatomic) BOOL isEditState;
@property (weak,nonatomic) UIButton *deButton;

@end

@implementation UCUploadHomePageViewController{
    NSMutableArray *selectDeleteModelArray;
    NSInteger currentvcIndex;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)configUI{
    [super configUI];
    self.title = @"我的上传";
    
    _isEditState = NO;

    /// nav item

    UIButton *deButton = UIButton.new;
    _deButton = deButton;
    [deButton setImage:[UIImage imageNamed:@"home_icon_remove"] forState:UIControlStateNormal];
    [deButton setImage:[UIImage new] forState:UIControlStateSelected];
    [deButton setTitle:@"取消" forState:UIControlStateSelected];
    [deButton setTitleColor:UIColor.EDJGrayscale_11 forState:UIControlStateSelected];
    [deButton addTarget:self action:@selector(navDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [UIBarButtonItem.alloc initWithCustomView:deButton];
    
    UIBarButtonItem *upload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"uc_icon_nav_item_upload"] style:UIBarButtonItemStyleDone target:self action:@selector(navUploadClick)];
    self.navigationItem.rightBarButtonItems = @[upload,right];
    
    for (DJUcMyCollectBaseViewController *subvc in self.childViewControllers) {
        subvc.delegate = self;
    }
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
        self.bottom.asbState = YES;
    }else{
        self.bottom.asbState = NO;
    }
}
- (void)ucmcAllSelectClickWhenEdit:(NSArray<DJUcMyCollectModel *> *)array{
    [self allSelectCommenHandle:array];
}

/// 我的上传 -- 思想汇报 和 述职述廉 单独处理
- (void)ucmp_mindCellClickWhenEdit:(DJThoutghtRepotListModel *)model modelArrayCount:(NSInteger)count{
    if (model.select) {
        /// 添加
        [selectDeleteModelArray addObject:model];
    }else{
        /// 删除
        [selectDeleteModelArray removeObject:model];
    }
    if (selectDeleteModelArray.count == count) {
        self.bottom.asbState = YES;
    }else{
        self.bottom.asbState = NO;
    }
}
- (void)ucmp_mindAllSelectClickWhenEdit:(NSArray<DJThoutghtRepotListModel *> *)array{
    [self allSelectCommenHandle:array];
}

- (void)allSelectCommenHandle:(NSArray *)array{
    if (array) {
        selectDeleteModelArray = [NSMutableArray arrayWithArray:array];
    }else{
        [selectDeleteModelArray removeAllObjects];
    }
}


#pragma mark - UCUploadTransitionViewDelegate
- (void)utViewClose:(UCUploadTransitionView *)utView{
    [utView removeFromSuperview];
    utView = nil;
}
- (void)utView:(UCUploadTransitionView *)utView action:(UploadTransitionAction)action{
    [utView removeFromSuperview];
    utView = nil;
    switch (action) {
        case UploadTransitionActionMemeberStage:{
            UCUploadPyqViewController *upvc = UCUploadPyqViewController.new;
            upvc.pushWay = LGBaseViewControllerPushWayModal;
            LGBaseNavigationController *nav = [LGBaseNavigationController.alloc initWithRootViewController:upvc];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:nav animated:YES completion:nil];

        }
            break;
        case UploadTransitionActionMindReport:{
            [self lg_presentUploadvcWithType:6];
            
        }
            break;
        case UploadTransitionActionSpeakCheap:{
            [self lg_presentUploadvcWithType:7];
            
        }
            break;
        
    }
}

- (void)lg_presentUploadvcWithType:(NSInteger)listType{
    DJUploadMindReportController *upvc = DJUploadMindReportController.new;
    upvc.pushWay = LGBaseViewControllerPushWayModal;
    upvc.listType = listType;
    LGBaseNavigationController *nav = [LGBaseNavigationController.alloc initWithRootViewController:upvc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - target
/// MARK: 导航栏删除按钮点击事件
- (void)navDeleteClick:(UIButton *)sender{
    
    if (!selectDeleteModelArray) {
        selectDeleteModelArray = NSMutableArray.new;
    }
    sender.selected = !sender.selected;
    
    /// 改变编辑状态
    self.isEditState = !_isEditState;
    
}

- (void)setIsEditState:(BOOL)isEditState{
    _isEditState = isEditState;
    
    /// 赋值父类的编辑属性
    self.isEdit = isEditState;
    _deButton.selected = isEditState;
    
    if (isEditState) {
        /// 当前子控制器 进入编辑状态
        [self subvcPerformSelector:@selector(startEdit)];
    }else{
        /// 当前子控制器 退出编辑状态
        [self exitEditState];
    }
    
}

#pragma mark - LGSegmentBottomViewDelegate
/// MARK: 编辑状态下，点击全选
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
    [self subvcPerformSelector:@selector(allSelect)];
}

/// MARK: 编辑状态下 点击删除
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
    /// 确认删除
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0; i < selectDeleteModelArray.count; i++) {
        id model = selectDeleteModelArray[i];
        if ([model isKindOfClass:[DJUcMyCollectModel class]]) {
            DJUcMyCollectModel *collectModel = model;
            [arrmu addObject:@(collectModel.seqid)];
        }
        if ([model isKindOfClass:[DJThoutghtRepotListModel class]]) {
            DJThoutghtRepotListModel *trModel = model;
            [arrmu addObject:@(trModel.seqid)];
        }
        
    }
    
    NSString *seqid_s = [arrmu componentsJoinedByString:@","];
    
    /// TODO: 如果需要在删除前 让用户确认，再次添加 alert
    
    if (seqid_s == nil || [seqid_s isEqualToString:@""]) {
        return;
    }
    
    /// MARK: 发送删除我的上传 请求
    [DJUserNetworkManager.sharedInstance frontUgc_deleteWithSeqids:seqid_s success:^(id responseObj) {
        [self exitEditState];
        [self.currentSubvc subvcReloadData];
    } failure:^(id failureObj) {
        [self presentFailureTips:op_failure_notice];
    }];
    
}

/// MARK: 退出编辑状态
- (void)exitEditState{
    _isEditState = NO;
    self.isEdit = NO;
    _deButton.selected = NO;
    self.bottom.asbState = NO;
    [self subvcPerformSelector:@selector(endEdit)];
}

- (void)viewSwitched:(NSInteger)index{
    if (self.isEditState) {
        self.isEditState = NO;
    }
    currentvcIndex = index;
}

#pragma mark - getter
- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"党员舞台",
               LGSegmentItemViewControllerClassKey:@"DJUcMyUploadPYQListController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"思想汇报",
               LGSegmentItemViewControllerClassKey:@"DJUcMyUploadMindReportListController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"述廉报告",
               LGSegmentItemViewControllerClassKey:@"DJUcMyUploadCheapSpeechListController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}

- (void)subvcPerformSelector:(SEL)action{
    /// 获取当前子控制器
    [self.currentSubvc performSelector:action];
}

- (DJUcMyCollectBaseViewController *)currentSubvc{
    return self.childViewControllers[currentvcIndex];
}

/// MARK: 点击导航栏 上传按钮
- (void)navUploadClick{
    UCUploadTransitionView *utv = [UCUploadTransitionView uploadTransitionView];
    utv.delegate = self;
    utv.frame = self.view.bounds;
    [self.view addSubview:utv];
}

@end
