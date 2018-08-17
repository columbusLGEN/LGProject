//
//  DCSubStageTableviewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageTableviewController.h"
#import "DCSubStageBaseTableViewCell.h"
#import "DCSubStageModel.h"
#import "DCSubStageCommentsModel.h"
#import "DJDiscoveryNetworkManager.h"
#import "DJUserInteractionMgr.h"
#import <WMPlayer/WMPlayer.h>
#import "HZPhotoBrowser.h"

@interface DCSubStageTableviewController ()<
DCSubStageBaseTableViewCellDelegate,
WMPlayerDelegate>
@property (assign,nonatomic) NSInteger offset;
@property (weak,nonatomic) WMPlayer * wmPlayer;

@end

@implementation DCSubStageTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 1.0;
    [self.tableView registerClass:[NSClassFromString(threeImgCell) class] forCellReuseIdentifier:threeImgCell];
    [self.tableView registerClass:[NSClassFromString(oneImgCell) class] forCellReuseIdentifier:oneImgCell];
    [self.tableView registerClass:[NSClassFromString(audioCell) class] forCellReuseIdentifier:audioCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
}
- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    _offset = dataArray.count;
    [self.tableView reloadData];
}

- (void)getData{
    [DJDiscoveryNetworkManager.sharedInstance frontUgc_selectmechanismWithOffset:_offset success:^(id responseObj) {
        
        if (_offset == 0) {
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
            if (_offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
                
            }
            
            for (NSInteger i = 0; i < array.count; i++) {
                DCSubStageModel *model = [DCSubStageModel mj_objectWithKeyValues:array[i]];
                [arrmu addObject:model];
            }
            self.dataArray = arrmu.copy;
            _offset = self.dataArray.count;
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
    DCSubStageModel *model = self.dataArray[indexPath.row];
    DCSubStageBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DCSubStageBaseTableViewCell cellReuseIdWithModel:model]];
    cell.delegate = self;
    cell.model = model;
    
    return cell;
}

- (void)pyqLikeWithModel:(DCSubStageModel *)model{
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:NO type:DJDataPraisetypeStage success:^(NSInteger cbkid, NSInteger cbkCount) {
    } failure:^(id failureObj) {
        [self presentFailureTips:@"点赞失败，请稍后重试"];
    }];
}
- (void)pyqCollectWithModel:(DCSubStageModel *)model{
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:YES type:DJDataPraisetypeStage success:^(NSInteger cbkid, NSInteger cbkCount) {
    } failure:^(id failureObj) {
        [self presentFailureTips:@"收藏失败，请稍后重试"];
    }];
}
- (void)pyqCommentWithModel:(DCSubStageModel *)model{
    [DJDiscoveryNetworkManager.sharedInstance frontComments_addWithCommentid:model.seqid commenttype:1 comment:@"测试评论" success:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
    
}
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

- (void)pyqCellplayVideoWithModel:(DCSubStageModel *)model{
    
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

-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)backBtn{
    [wmplayer pause];
    [wmplayer removeFromSuperview];
    _wmPlayer = nil;
}

@end
