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
#import "HPSearchViewController.h"
#import "DJDataSyncer.h"

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

@implementation EDJDiscoveryViewController{
    NSDate *QA_startDate;
    NSDate *PYQ_startDate;
    NSTimeInterval QA_seconds;
    NSTimeInterval PYQ_seconds;
    DJDataSyncer *dataSyncer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    /// 页面默认展示学习问答，所以:
    if (_currentChannel == 0) {
        QA_startDate = [NSDate date];
//        NSLog(@"当前展示学习问答: ");
    }
    if (_currentChannel == 2) {
//        NSLog(@"当前展示党员舞台: ");
        PYQ_startDate = [NSDate date];
    }
    QA_seconds = 0;
    PYQ_seconds = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)configUI{
    [super configUI];
    
    dataSyncer = DJDataSyncer.new;
    
    _currentChannel = 0;
    
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    _fakeNavgationBar = fakeNavgationBar;
    [self viewSwitched:0];
    
    fakeNavgationBar.delegate = self;
    [self.view addSubview:fakeNavgationBar];
    
    [self getData];
    
}

- (void)getData{
    
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
        dataSyncer.dicovery_QA = qavc.dataArray;
        qavc.dataSyncer = dataSyncer;
        
        /// 支部动态
        DCSubPartStateTableViewController *branchvc = self.childViewControllers[1];
        NSMutableArray *arrmu_br = NSMutableArray.new;
        for (NSInteger i = 0; i < branch.count; i++) {
            DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:branch[i]];
            [arrmu_br addObject:model];
        }
        branchvc.dataArray = arrmu_br.copy;
        dataSyncer.dicovery_branch = branchvc.dataArray;
        branchvc.dataSyncer = dataSyncer;
        
        /// 党员舞台
        DCSubStageTableviewController *pyqvc = self.childViewControllers[2];
        NSMutableArray *arrmu_pyq = NSMutableArray.new;
        for (NSInteger i = 0; i < ugc.count; i++) {
            DCSubStageModel *model = [DCSubStageModel mj_objectWithKeyValues:ugc[i]];
            [arrmu_pyq addObject:model];
        }
        pyqvc.dataArray = arrmu_pyq.copy;
        dataSyncer.dicovery_PYQ = pyqvc.dataArray;
        pyqvc.dataSyncer = dataSyncer;
        
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
//        upvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        LGBaseNavigationController *nav = [LGBaseNavigationController.alloc initWithRootViewController:upvc];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        
    }
    
}
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar{
    HPSearchViewController *svc = HPSearchViewController.new;
    svc.dataSyncer = dataSyncer;
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)voiceButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    HPSearchViewController *svc = HPSearchViewController.new;
    svc.voice = YES;
    svc.dataSyncer = dataSyncer;
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)viewSwitched:(NSInteger)index{
    
    /// 上一个页面的索引
    NSInteger lastIndex = _currentChannel;
    if ((lastIndex == 1 || lastIndex == 2) && index == 0) {
//        NSLog(@"开始查看学习问答: ");
        QA_startDate = [NSDate date];
    }
    
    if (lastIndex == 0 && index != 0) {
        /// 结束学习问答查看
        [self calculateQASecond];
        
    }
    
    if ((lastIndex == 1 || lastIndex == 0) && index == 2) {
//        NSLog(@"开始查看党员舞台: ");
        PYQ_startDate = [NSDate date];
        
    }
    
    if (lastIndex == 2 && index != 2) {
        /// 结束党员舞台查看
        [self calculatePYQSecond];
    }
    
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_currentChannel == 0) {
        /// 该页面销毁时，用户停留在 学习问答视图
        [self calculateQASecond];
    }
    
    if (_currentChannel == 2) {
        /// 该页面销毁时，用户停留在 党员舞台视图
        [self calculatePYQSecond];
    }
    
    /// 增加积分
    if (QA_seconds != 0) {
        NSTimeInterval QA_mins = QA_seconds / 60;
        [DJUserNetworkManager.sharedInstance frontIntegralGrade_addWithIntegralid:DJUserAddScoreTypeReadQA completenum:QA_mins success:^(id responseObj) {
            
        } failure:^(id failureObj) {
            
        }];
    }
    if (PYQ_seconds != 0) {
        NSTimeInterval PYQ_mins = PYQ_seconds / 60;
        [DJUserNetworkManager.sharedInstance frontIntegralGrade_addWithIntegralid:DJUserAddScoreTypeReadPYQ completenum:PYQ_mins success:^(id responseObj) {
            
        } failure:^(id failureObj) {
            
        }];
    }
}

- (void)calculateQASecond{
    NSTimeInterval qaseconds = [self secondSinceNowWithDate:QA_startDate];
    QA_seconds += qaseconds;
}
- (void)calculatePYQSecond{
    NSTimeInterval pyqseconds = [self secondSinceNowWithDate:PYQ_startDate];
    PYQ_seconds += pyqseconds;
}

/// MARK: date 距离现在的时间差
- (NSTimeInterval)secondSinceNowWithDate:(NSDate *)date{
    NSDate *currentDate = [NSDate date];
    return [currentDate timeIntervalSinceDate:date];
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
