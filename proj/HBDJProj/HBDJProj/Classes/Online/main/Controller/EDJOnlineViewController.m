//
//  EDJOnlineViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJOnlineViewController.h"

#import "LGNavigationSearchBar.h"
#import "HPNetworkFailureView.h"

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
,LGNavigationSearchBarDelelgate,
HPNetworkFailureViewDelegate>
@property (strong,nonatomic) EDJOnlineController *onlineController;
@property (strong,nonatomic) UIImageView *headLine;
@property (strong,nonatomic) DJOnlineHomeModel *model;
@property (strong,nonatomic) HPNetworkFailureView *online_home_emptyView;

@end

@implementation EDJOnlineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.onlineController getDataWithPlistName:@"OLHomeItems"];/// 添加“更多”
    [self.view addSubview:self.onlineController.collectionView];
    self.onlineController.collectionView.delegate = self;
    
    LGNavigationSearchBar *nav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    nav.delegate = self;
    [self.view addSubview:nav];
    [self.onlineController.collectionView addSubview:self.headLine];
    
    self.onlineController.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNetData];
    }];
    self.onlineController.collectionView.mj_header.ignoredScrollViewContentInsetTop = [EDJOnlineController headerHeight] + 10;
    
    [self.onlineController.collectionView.mj_header beginRefreshing];
}

/// 获取数据
- (void)loadNetData{
    
    /// TODO: 在线首页获取数据优化
    // 1.获取当前时间戳
    // 2.将当前时间戳保存到本地
    // 3.获取本地时间戳
    // 4.获取 （当前 - 本地） 的差值
    // 5.if 本地值存在 || 差值 >= 86400 --> 执行请求并且执行2, 并将数据缓存到本地
    // 6.else 获取本地缓存数据
    
    [[DJOnlineNetorkManager sharedInstance] onlineHomeConfigSuccess:^(id responseObj) {
        [self.onlineController.collectionView.mj_header endRefreshing];
        [self removeEmptyView];
        self.model = [DJOnlineHomeModel mj_objectWithKeyValues:responseObj];
        self.onlineController.onlineModels = self.model.activation;
        
        [self.headLine sd_setImageWithURL:[NSURL URLWithString:self.model.headlineImg] placeholderImage:DJImgloopPImage];
        
    } failure:^(id failureObj) {
        [self.onlineController.collectionView.mj_header endRefreshing];
        [self presentFailureTips:@"网络异常"];
        [self addEmptyView];
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
/// MARK: LGNavigationSearchBarDelelgate
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
/// MARK: HPNetworkFailureView
- (void)djemptyViewClick{
    [self loadNetData];
}

- (void)addEmptyView{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!_online_home_emptyView) {
            [self.view addSubview:self.online_home_emptyView];
        }
    }];
}
- (void)removeEmptyView{
    if (_online_home_emptyView) {
        [_online_home_emptyView removeFromSuperview];
        _online_home_emptyView = nil;
    }
}

- (HPNetworkFailureView *)online_home_emptyView{
    if (!_online_home_emptyView) {
        _online_home_emptyView = [HPNetworkFailureView DJEmptyView];
        _online_home_emptyView.frame = self.view.bounds;
        _online_home_emptyView.delegate = self;
    }
    return _online_home_emptyView;
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
