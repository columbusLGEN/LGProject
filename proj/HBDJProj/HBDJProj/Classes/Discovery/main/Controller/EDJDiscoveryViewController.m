//
//  EDJDiscoveryViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJDiscoveryViewController.h"
#import "LGNavigationSearchBar.h"
#import "DCWriteQuestionViewController.h"
#import "UCMemberStageTransitionView.h"

typedef NS_ENUM(NSUInteger, DiscoveryChannel) {
    DiscoveryChannelQuestionCommunity,
    DiscoveryChannelBranchStatus,
    DiscoveryChannelMemberStage,
};

@interface EDJDiscoveryViewController ()<
LGNavigationSearchBarDelelgate>
@property (weak,nonatomic) LGNavigationSearchBar *fakeNavgationBar;
/** 0:学习问答,1:支部动态,2:党员舞台 */
@property (assign,nonatomic) NSInteger currentChannel;

@end

@implementation EDJDiscoveryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)configUI{
    [super configUI];
    
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    fakeNavgationBar.isShowRightBtn = YES;
    fakeNavgationBar.rightButtonTitle = @"提问";
    fakeNavgationBar.delegate = self;
    [self.view addSubview:fakeNavgationBar];
    _fakeNavgationBar = fakeNavgationBar;

}
#pragma mark - LGNavigationSearchBarDelelgate
- (void)navRightButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    if (_currentChannel == 0) {
        /// 提问
        DCWriteQuestionViewController *question = [DCWriteQuestionViewController new];
        question.pushWay = LGBaseViewControllerPushWayModal;
        LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:question];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (_currentChannel == 2){
        /// 上传党员舞台 （朋友圈）
        UCMemberStageTransitionView *mstView = [UCMemberStageTransitionView memberStateTransitionView];
        mstView.delegate = self;
        CGFloat mstH = kScreenHeight + kStatusBarHeight;
        if (kScreenHeight == 812) {
            mstH += 34;
        }
        mstView.frame = CGRectMake(0, -kStatusBarHeight, kScreenWidth, mstH);
        //            [self.view addSubview:mstView];
        /// TODO:添加到self.view上 无法遮挡导航栏，所以 暂时加到 keywindow上，不是最优解
        [[UIApplication sharedApplication].keyWindow addSubview:mstView];
    }else{
        
    }
    
}


- (void)viewSwitched:(NSInteger)index{
    if (index == 0) {
        self.fakeNavgationBar.isShowRightBtn = YES;
        self.fakeNavgationBar.rightButtonTitle = @"提问";
    }else if(index == 1){
        self.fakeNavgationBar.isShowRightBtn = NO;
    }else{
        self.fakeNavgationBar.isShowRightBtn = YES;
        self.fakeNavgationBar.rightButtonTitle = @"投稿";
    }
    _currentChannel = index;
}

- (NSArray<NSDictionary *> *)segmentItems{
    /**
     DCQuestionCommunityViewController
     DCSubPartStateTableViewController
     DCSubStageTableviewController
     */
    return @[@{LGSegmentItemNameKey:@"学习问答",
               LGSegmentItemViewControllerClassKey:@"DCQuestionCommunityViewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"支部动态",
               LGSegmentItemViewControllerClassKey:@"DCSubPartStateTableViewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"党员舞台",
               LGSegmentItemViewControllerClassKey:@"DCSubStageTableviewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}

- (CGFloat)segmentTopMargin{
    return kNavSingleBarHeight + 10;
}

@end
