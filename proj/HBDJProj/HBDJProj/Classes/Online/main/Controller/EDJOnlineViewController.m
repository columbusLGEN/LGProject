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

#import "DJOnlineHomeModel.h"
#import "OLHomeModel.h"
#import "OLSkipObject.h"
#import "DJOnlineNetorkManager.h"
#import "DJOnlineSearchViewController.h"
#import "DJXGDJWebViewController.h"
#import "LGAlertControllerManager.h"

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
    /// 一天之内不重复请求 but 用户开通新功能之后需要发送请求 → 用户开通新功能后发送推送消息，app收到推送后发送新的请求
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
        
        /// 在线顶部 图片
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
        
    }else{
        
        NSString *currentTimestamp = [NSString getCurrentTimestamp];
//        NSLog(@"currentTimestamp: %@",currentTimestamp);
//        NSLog(@"currentTimestamp.floatValue: %f",currentTimestamp.floatValue);
//        NSLog(@"model.toolendtime: %@",model.toolendtime);
        
        if ((model.toolendtime.floatValue < currentTimestamp.floatValue) && !model.isDefault) {
            /// 工具已经过期
            NSString *number = [NSUserDefaults.standardUserDefaults objectForKey:dj_service_numberKey];
            NSString *msg = [NSString stringWithFormat:@"该工具有效期已结束，如需继续使用请联系%@",number];
            UIAlertController *alertvc = [LGAlertControllerManager alertvcWithTitle:@"提示" message:msg doneText:@"确定" doneBlock:^(UIAlertAction * _Nonnull action) {
                
            }];
            [self presentViewController:alertvc animated:YES completion:nil];
        }else{
            if (model.modelType == OnlineModelTypeSpeakCheapXG) {
                /// 孝感党建
                //            LGWKWebViewController *webvc = [LGWKWebViewController.alloc initWithUrl:[NSURL URLWithString:model.xiaoganurl]];
                DJXGDJWebViewController *webvc = [DJXGDJWebViewController.alloc initWithUrl:[NSURL URLWithString:model.xiaoganurl]];
                webvc.title = @"孝感党建";
                [self.navigationController pushViewController:webvc animated:YES];
            }else{
                /// 其余跳转
                [self.navigationController pushViewController:[OLSkipObject viewControllerWithOLHomeModelType:model] animated:YES];
            }
        }
        
        
        
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
    DJOnlineSearchViewController *searchvc = DJOnlineSearchViewController.new;
    searchvc.voice = voice;
    [self.navigationController pushViewController:searchvc animated:YES];
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
        _headLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, - [EDJOnlineController headerHeight], kScreenWidth, [EDJOnlineController headerHeight])];
        _headLine.clipsToBounds = YES;
        _headLine.contentMode = UIViewContentModeScaleAspectFill;
        _headLine.image = [UIImage imageNamed:@"online_top_icon"];
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
