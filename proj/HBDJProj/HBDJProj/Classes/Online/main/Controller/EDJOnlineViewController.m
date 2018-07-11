//
//  EDJOnlineViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJOnlineViewController.h"

#import "LGNavigationSearchBar.h"

#import "EDJOnlineController.h"
#import "OLAddMoreToolViewController.h"
#import "OLMindReportViewController.h"
#import "DJSearchViewController.h"

#import "DJTestScoreListTableViewController.h"/// testcode

#import "DJOnlineHomeModel.h"
#import "OLHomeModel.h"
#import "OLSkipObject.h"
#import "DJOnlineNetorkManager.h"

static CGFloat headLineHeight = 233;

@interface EDJOnlineViewController ()<
UICollectionViewDelegate
,LGNavigationSearchBarDelelgate>
@property (strong,nonatomic) EDJOnlineController *onlineController;
@property (strong,nonatomic) UIImageView *headLine;
@property (strong,nonatomic) DJOnlineHomeModel *model;

@end

@implementation EDJOnlineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.onlineController getDataWithPlistName:@"OLHomeItems"];
    [self.view addSubview:self.onlineController.collectionView];
    self.onlineController.collectionView.delegate = self;
    
    LGNavigationSearchBar *nav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    nav.delegate = self;
    [self.view addSubview:nav];
    [self.onlineController.collectionView addSubview:self.headLine];
    
    /// 获取数据
    [[DJOnlineNetorkManager sharedInstance] onlineHomeConfigSuccess:^(id responseObj) {
        NSLog(@"res_class: %@",[responseObj class]);
        self.model = [DJOnlineHomeModel mj_objectWithKeyValues:responseObj];
        self.onlineController.onlineModels = self.model.activation;
        
        [self.headLine sd_setImageWithURL:[NSURL URLWithString:self.model.headlineImg] placeholderImage:DJImgloopPImage];
        
    } failure:^(id failureObj) {
        [self presentFailureTips:@"网络异常"];
        
    }];
    
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OLHomeModel *model = self.onlineController.onlineModels[indexPath.row];
    if (indexPath.item == self.onlineController.onlineModels.count - 1) {
        /// 跳转至 添加更多工具
        if (self.model) {
            OLAddMoreToolViewController *vc = [OLAddMoreToolViewController new];
            vc.array = self.model.notactive;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            vc.pushWay = LGBaseViewControllerPushWayModal;
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        /// 跳转测试 -- 进入成绩统计排行，此页面入口在哪里
//        DJTestScoreListTableViewController *vc = DJTestScoreListTableViewController.new;
//        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        /// 其余跳转
        [self.navigationController pushViewController:[OLSkipObject viewControllerWithOLHomeModelType:model] animated:YES];
    }
}
#pragma mark - LGNavigationSearchBarDelelgate
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self beginSearchWithVoice:NO];
}
- (void)voiceButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self beginSearchWithVoice:YES];
}
- (void)beginSearchWithVoice:(BOOL)voice{
    DJSearchViewController *searchVc = [DJSearchViewController new];
    searchVc.voice = voice;
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (UIImageView *)headLine{
    if (_headLine == nil) {
        _headLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, - [EDJOnlineController headerHeight] - 9, kScreenWidth, headLineHeight)];
        _headLine.clipsToBounds = YES;
        _headLine.contentMode = UIViewContentModeScaleAspectFill;
        _headLine.image = [UIImage imageNamed:@"party_history"];
    }
    return _headLine;
}

- (EDJOnlineController *)onlineController{
    if (_onlineController == nil) {
        _onlineController = [EDJOnlineController new];
    }
    return _onlineController;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
