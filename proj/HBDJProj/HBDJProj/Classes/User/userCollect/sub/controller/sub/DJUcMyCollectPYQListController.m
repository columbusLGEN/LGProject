//
//  DJUcMyCollectPYQListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectPYQListController.h"
#import "DCSubStageBaseTableViewCell.h"
#import "DJUcMyCollectPYQModel.h"
#import "DCSubStageCommentsModel.h"
#import "DJUserNetworkManager.h"
#import "DJUserInteractionMgr.h"
#import <WMPlayer/WMPlayer.h>
#import "HZPhotoBrowser.h"
#import "DJSendCommentsViewController.h"
#import "DCSubStageAudioCell.h"
#import "DJPyqAudioPlayViewController.h"

@interface DJUcMyCollectPYQListController ()<
DCSubStageBaseTableViewCellDelegate,
WMPlayerDelegate>
@property (weak,nonatomic) WMPlayer * wmPlayer;

@end

@implementation DJUcMyCollectPYQListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 1.0;
    [self.tableView registerClass:[NSClassFromString(threeImgCell) class] forCellReuseIdentifier:threeImgCell];
    [self.tableView registerClass:[NSClassFromString(oneImgCell) class] forCellReuseIdentifier:oneImgCell];
    [self.tableView registerClass:[NSClassFromString(audioCell) class] forCellReuseIdentifier:audioCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    self.offset = dataArray.count;
    [self.tableView reloadData];
}

- (void)getData{
    [DJUserNetworkManager.sharedInstance frontUserCollections_selectWithType:5 offset:self.offset success:^(id responseObj) {
        
        if (self.offset == 0) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_header endRefreshing];
        }
        
        NSArray *array = responseObj;
        
        if (array == nil || array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }else{
            [self.tableView.mj_footer endRefreshing];
            
            NSMutableArray *arrmu;
            if (self.offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
                
            }
            
            for (NSInteger i = 0; i < array.count; i++) {
                DCSubStageModel *model = [DCSubStageModel mj_objectWithKeyValues:array[i]];
                [arrmu addObject:model];
            }
            self.dataArray = arrmu.copy;
            self.offset = self.dataArray.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJUcMyCollectPYQModel *model = self.dataArray[indexPath.row];
    DCSubStageBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DCSubStageBaseTableViewCell cellReuseIdWithModel:model]];
    cell.delegate = self;
    cell.mc_pyq_model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /// 编辑状态
    
    /// 普通状态
    DCSubStageModel *model = self.dataArray[indexPath.row];
    if (model.filetype == 3) {
        DJPyqAudioPlayViewController *audioPlayVc = DJPyqAudioPlayViewController.new;
        audioPlayVc.model = model;
        audioPlayVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        audioPlayVc.pushWay = LGBaseViewControllerPushWayModal;
        audioPlayVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:audioPlayVc animated:YES completion:nil];
    }
}

- (void)pyqLikeWithModel:(DCSubStageModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:NO type:DJDataPraisetypeStage success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"点赞失败，请稍后重试"];
    }];
}
- (void)pyqCollectWithModel:(DCSubStageModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:YES type:DJDataPraisetypeStage success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"收藏失败，请稍后重试"];
    }];
}
/// MARK: 发表评论
- (void)pyqCommentWithModel:(DCSubStageModel *)model sender:(UIButton *)sender{
    
    DJSendCommentsViewController *vc = [DJSendCommentsViewController sendCommentvcWithModel:model];
    vc.commenttype = 1;
    [self presentViewController:vc animated:YES completion:nil];
    
}
/// MARK: 单图点击
- (void)pyqCellOneImageClick:(DCSubStageBaseTableViewCell *)cell model:(DCSubStageModel *)model imageView:(UIImageView *)imageView{
    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.sourceImagesContainerView = cell.contentView; // 原图的父控件
    //    browser.currentImageIndex = (int)button.tag;
    //    browser.imageCount = 1; // 图片总数
    browser.imageArray = @[model.fileurl];
    
    browser.delegate = cell;
    [browser show];
}

/// MARK:播放视频
- (void)pyqCellplayVideoWithModel:(DCSubStageModel *)model{
    
    /// TODO: 非wifi播放提醒
    /// TODO: 朋友圈播放视频重构
    
    WMPlayerModel *playerModel = [WMPlayerModel new];
    //    playerModel.title = model.title;
    playerModel.videoURL = [NSURL URLWithString:model.fileurl];
    playerModel.verticalVideo = (model.aImgType == StageModelTypeAImgTypeVer);
    WMPlayer * wmPlayer = [[WMPlayer alloc]initPlayerModel:playerModel];
    _wmPlayer = wmPlayer;
    _wmPlayer.backBtnStyle = BackBtnStylePop;
    _wmPlayer.delegate = self;
    _wmPlayer.tintColor = UIColor.EDJMainColor;
    _wmPlayer.loopPlay = NO;
    _wmPlayer.playerLayerGravity = WMPlayerLayerGravityResizeAspect;
    [UIApplication.sharedApplication.keyWindow addSubview:_wmPlayer];
    
    [_wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.leading.trailing.top.equalTo(UIApplication.sharedApplication.keyWindow);
        //        make.height.mas_equalTo(wmPlayer.mas_width).multipliedBy(9.0/16);
        make.edges.equalTo(UIApplication.sharedApplication.keyWindow);
    }];
    [_wmPlayer play];
    
}
/// MARK: 关闭视频
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)backBtn{
    [wmplayer pause];
    [wmplayer removeFromSuperview];
    _wmPlayer = nil;
}

@end
