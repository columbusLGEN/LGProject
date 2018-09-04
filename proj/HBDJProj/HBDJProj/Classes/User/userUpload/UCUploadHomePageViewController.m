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

@interface UCUploadHomePageViewController ()<
UCUploadTransitionViewDelegate,
LGSegmentBottomViewDelegate
>
/** 是否是编辑状态，默认为no */
@property (assign,nonatomic) BOOL isEditState;
@property (weak,nonatomic) UIButton *deButton;

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

- (void)setIsEditState:(BOOL)isEditState{
    _isEditState = isEditState;
    self.isEdit = isEditState;/// 父类属性
    _deButton.selected = isEditState;
    
    DJUcMyUploadPYQListController *mupyqvc = self.childViewControllers[0];
    DJUcMyUploadMindReportListController *mumrvc = self.childViewControllers[1];
    DJUcMyUploadCheapSpeechListController *mucsvc = self.childViewControllers[2];
    if (isEditState) {
        [mupyqvc startEdit];
        [mumrvc startEdit];
        [mucsvc startEdit];
        
    }else{
        [mupyqvc endEdit];
        [mumrvc endEdit];
        [mucsvc endEdit];
    }
    
}

#pragma mark - target
/// MARK: 进入编辑状态
- (void)navDeleteClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (!self.isEditState) {
        self.isEditState = YES;
        
    }else{
        self.isEditState = NO;
        
    }
}

#pragma mark - LGSegmentBottomViewDelegate
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
    DJUcMyUploadPYQListController *mupyqvc = self.childViewControllers[0];
    DJUcMyUploadMindReportListController *mumrvc = self.childViewControllers[1];
    DJUcMyUploadCheapSpeechListController *mucsvc = self.childViewControllers[2];
    
    [mupyqvc allSelect];
    [mumrvc allSelect];
    [mucsvc allSelect];
    
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
    /// TODO: 切换分页，或者刷新的时候 恢复默认状态
    if (self.isEditState) {
        self.isEditState = NO;
        
    }
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

@end
