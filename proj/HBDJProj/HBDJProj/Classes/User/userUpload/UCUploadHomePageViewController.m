//
//  UCUploadHomePageViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadHomePageViewController.h"
#import "UCPartyMemberStageController.h"
#import "UCPartyMemberStageModel.h"
#import "UCUploadTransitionView.h"
#import "LGSegmentBottomView.h"

@interface UCUploadHomePageViewController ()<
UCUploadTransitionViewDelegate,
LGSegmentBottomViewDelegate
>
/** 是否是编辑状态，默认为no */
@property (assign,nonatomic) BOOL isEditState;

@end

@implementation UCUploadHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
- (void)configUI{
    [super configUI];
    self.title = @"我的上传";
    
    self.isEditState = NO;

    /// nav item
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_icon_remove"] style:UIBarButtonItemStyleDone target:self action:@selector(navDeleteClick)];
    UIBarButtonItem *upload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"uc_icon_nav_item_upload"] style:UIBarButtonItemStyleDone target:self action:@selector(navUploadClick)];
    self.navigationItem.rightBarButtonItems = @[upload,delete];
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
            /// TODO:上传 党员舞台（朋友圈）
            

        }
            break;
        case UploadTransitionActionMindReport:{
            /// TODO:上 思想汇报
            
        }
            break;
        case UploadTransitionActionSpeakCheap:{
            /// TODO:上 述职述廉
            
        }
            break;
        
    }
}

- (void)setIsEditState:(BOOL)isEditState{
    _isEditState = isEditState;
    self.isEdit = isEditState;/// 父类属性
}

#pragma mark - target
/// MARK: 进入编辑状态
- (void)navDeleteClick{
    /// TODO: 判断当前位置，党员舞台，思想汇报，述廉报告 分别处理
    if (!self.isEditState) {
        self.isEditState = YES;
        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UCPartyMemberStageController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj startEdit];
        }];
    }else{
        self.isEditState = NO;
        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UCPartyMemberStageController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj endEdit];
        }];
    }
}

#pragma mark - LGSegmentBottomViewDelegate
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UCPartyMemberStageController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj allSelect];
    }];
    
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
    NSLog(@"子类删除 -- ");
}

- (void)navUploadClick{
    UCUploadTransitionView *utv = [UCUploadTransitionView uploadTransitionView];
    utv.delegate = self;
    utv.frame = self.view.bounds;
    [self.view addSubview:utv];
}

- (void)viewSwitched:(NSInteger)index{
    NSLog(@"index -- %ld",index);
    /// TODO: 切换分页，或者刷新的时候 恢复默认状态
    if (self.isEditState) {
        self.isEditState = NO;
        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UCPartyMemberStageController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj endEdit];
        }];
    }
}

#pragma mark - getter
- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"党员舞台",
               LGSegmentItemViewControllerClassKey:@"UCPartyMemberStageController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeStoryboard
               },
             @{LGSegmentItemNameKey:@"思想汇报",
               LGSegmentItemViewControllerClassKey:@"UCPartyMemberStageController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeStoryboard
               },
             @{LGSegmentItemNameKey:@"述廉报告",
               LGSegmentItemViewControllerClassKey:@"UCPartyMemberStageController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeStoryboard
               }];
}

@end
