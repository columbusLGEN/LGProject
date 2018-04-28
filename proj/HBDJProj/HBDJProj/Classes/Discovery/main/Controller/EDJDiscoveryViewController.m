//
//  EDJDiscoveryViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJDiscoveryViewController.h"
#import "LGNavigationSearchBar.h"
#import "LGBaseNavigationController.h"
#import "QA/DCWriteQuestionViewController.h"

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
    DCWriteQuestionViewController *question = [DCWriteQuestionViewController new];
    [self.navigationController pushViewController:question animated:YES];

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
