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
#import "UCUploadPyqViewController.h"
#import "DJDiscoveryNetworkManager.h"
#import "DCQuestionCommunityViewController.h"
#import "UCQuestionModel.h"
#import "DCSubPartStateTableViewController.h"
#import "DCSubPartStateModel.h"
#import "DCSubStageTableviewController.h"
#import "DCSubStageModel.h"

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
    
    [self getData];
    
}

- (void)getData{
    
    /// 测试数据
//    NSString *filePaht = [[NSBundle mainBundle] pathForResource:@"testJson" ofType:@"txt"];
//    NSString *jsonString = [NSString stringWithContentsOfFile:filePaht encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    id responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//    if (error) {
//        NSLog(@"error: %@",error);
//        NSLog(@"anything: %@",error.localizedDescription);
//    }
    
    [DJDiscoveryNetworkManager.sharedInstance frontIndex_findIndexWithSuccess:^(id responseObj) {

        NSArray *questionanswer = responseObj[@"questionanswer"];// 学习问答
        NSArray *branch = responseObj[@"branch"];// 支部动态
        NSArray *ugc = responseObj[@"ugc"];// 朋友圈
        
        /// 学习问答
        DCQuestionCommunityViewController *qavc = self.childViewControllers[0];
        NSMutableArray *arrmu_qa = NSMutableArray.new;
        for (NSInteger i = 0; i < questionanswer.count; i++) {
            /// 字典转模型
            UCQuestionModel *model = [UCQuestionModel mj_objectWithKeyValues:questionanswer[i]];
            [arrmu_qa addObject:model];
        }
        qavc.dataArray = arrmu_qa.copy;
        
        /// 支部动态
        DCSubPartStateTableViewController *branchvc = self.childViewControllers[1];
        NSMutableArray *arrmu_br = NSMutableArray.new;
        for (NSInteger i = 0; i < branch.count; i++) {
            DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:branch[i]];
            [arrmu_br addObject:model];
        }
        branchvc.dataArray = arrmu_br.copy;
        
        /// 党员舞台
        DCSubStageTableviewController *pyqvc = self.childViewControllers[2];
        NSMutableArray *arrmu_pyq = NSMutableArray.new;
        for (NSInteger i = 0; i < ugc.count; i++) {
            DCSubStageModel *model = [DCSubStageModel mj_objectWithKeyValues:ugc[i]];
            [arrmu_pyq addObject:model];
        }
        pyqvc.dataArray = arrmu_pyq.copy;
        
    } failure:^(id failureObj) {
        [self presentFailureTips:@"网络异常"];

    }];
    
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
        UCUploadPyqViewController *upvc = UCUploadPyqViewController.new;
        upvc.pushWay = LGBaseViewControllerPushWayModal;
        upvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:upvc animated:YES completion:nil];
        
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
