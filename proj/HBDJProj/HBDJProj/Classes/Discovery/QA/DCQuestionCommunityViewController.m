//
//  DCQuestionCommunityViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCQuestionCommunityViewController.h"
#import "UCQuestionTableViewCell.h"
#import "DJDiscoveryNetworkManager.h"
#import "UCQuestionModel.h"
#import "DJUserInteractionMgr.h"
#import "LGSocialShareManager.h"

static NSString * const cellID = @"UCQuestionTableViewCell";

@interface DCQuestionCommunityViewController ()<
UCQuestionTableViewCellDelegate>

@end

@implementation DCQuestionCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.estimatedRowHeight = 1.0;
    
//    NSMutableArray *arr = [NSMutableArray new];
//    for (int i = 0; i < 5; i++) {
//        UCQuestionModel *model = [UCQuestionModel new];
//        [arr addObject:model];
//    }
//    _array = arr.copy;
//    [self.tableView reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
}

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    _offset = dataArray.count;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)getData{
    [DJDiscoveryNetworkManager.sharedInstance frontQuestionanswer_selectmechanismWithOffset:_offset success:^(id responseObj) {
        NSArray *array = responseObj;
        
        if (_offset == 0) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_header endRefreshing];
        }
        
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
                UCQuestionModel *model = [UCQuestionModel mj_objectWithKeyValues:array[i]];
                [arrmu addObject:model];
            }
            self.dataArray = arrmu.copy;
            _offset = self.dataArray.count;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCQuestionModel *model = self.dataArray[indexPath.row];
    UCQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = model;
    return cell;
}

- (void)qaCellshowAllClickWith:(NSIndexPath *)indexPath{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
// 点赞
- (void)qaCellLikeWithModel:(UCQuestionModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:NO type:DJDataPraisetypeQA success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"点赞失败，请稍后重试"];
    }];
}
// 收藏
- (void)qaCellCollectWithModel:(UCQuestionModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:YES type:DJDataPraisetypeQA success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"收藏失败，请稍后重试"];
    }];
}
// 分享
- (void)qaCellShareWithModel:(UCQuestionModel *)model sender:(UIButton *)sender{
    
    /// TODO: 分享链接等内容
    NSDictionary *param = @{LGSocialShareParamKeyWebPageUrl:model.shareUrl?model.shareUrl:@"",
                            LGSocialShareParamKeyTitle:model.title?model.title:@"",
                            LGSocialShareParamKeyDesc:model.contentvalidity?model.contentvalidity:@"",
                            LGSocialShareParamKeyThumbUrl:model.thumbnail?model.thumbnail:@"",
                            LGSocialShareParamKeyVc:self};
    
    [[LGSocialShareManager new] showShareMenuWithParam:param];
}

@end
