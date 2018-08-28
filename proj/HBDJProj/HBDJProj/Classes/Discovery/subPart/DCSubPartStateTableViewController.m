//
//  DCSubPartStateTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateTableViewController.h"
#import "DCSubPartStateModel.h"
#import "DCSubPartStateBaseCell.h"
#import "DCSubPartStateWithoutImgCell.h"
#import "DCSubPartStateDetailViewController.h"
#import "DJDiscoveryNetworkManager.h"
#import "DCSubPartStateOneImgCell.h"
#import "DCSubPartStateThreeImgCell.h"
#import "DJUserInteractionMgr.h"

@interface DCSubPartStateTableViewController ()<DCSubPartStateBaseCellDelegate>

@end

@implementation DCSubPartStateTableViewController

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    _offset = dataArray.count;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 1.0;
    [self.tableView registerClass:[DCSubPartStateWithoutImgCell class] forCellReuseIdentifier:withoutImgCell];
    [self.tableView registerClass:[DCSubPartStateOneImgCell class] forCellReuseIdentifier:oneImgCell];
    [self.tableView registerClass:[DCSubPartStateThreeImgCell class]
         forCellReuseIdentifier:threeImgCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
}

- (void)getData{
    [DJDiscoveryNetworkManager.sharedInstance frontBranch_selectWithOffset:_offset success:^(id responseObj) {
        
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
                DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:array[i]];
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
    DCSubPartStateModel *model = self.dataArray[indexPath.row];
    DCSubPartStateBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DCSubPartStateBaseCell cellReuseIdWithModel:model]];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSubPartStateModel *model = self.dataArray[indexPath.row];
    DCSubPartStateDetailViewController *dvc = [DCSubPartStateDetailViewController new];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)branchLikeWithModel:(DCSubPartStateModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:NO type:DJDataPraisetypeState success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"点赞失败，请稍后重试"];
    }];
}
- (void)branchCollectWithModel:(DCSubPartStateModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:YES type:DJDataPraisetypeState success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"收藏失败，请稍后重试"];
    }];
}
- (void)branchCommentWithModel:(DCSubPartStateModel *)model{
    /// 跳转到详情页面，并弹出评论
    DCSubPartStateDetailViewController *dvc = [DCSubPartStateDetailViewController new];
    dvc.model = model;
    dvc.showCommentView = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
