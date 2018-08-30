//
//  DJUcMyCollectBranchListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectBranchListController.h"
#import "DCSubPartStateModel.h"
#import "DCSubPartStateBaseCell.h"
#import "DCSubPartStateWithoutImgCell.h"
#import "DCSubPartStateDetailViewController.h"
#import "DJDiscoveryNetworkManager.h"
#import "DCSubPartStateOneImgCell.h"
#import "DCSubPartStateThreeImgCell.h"
#import "DJUserInteractionMgr.h"

@interface DJUcMyCollectBranchListController ()<DCSubPartStateBaseCellDelegate>

@end

@implementation DJUcMyCollectBranchListController

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    self.offset = dataArray.count;
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
    
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0 ; i < 15; i++) {
        DCSubPartStateModel *model = DCSubPartStateModel.new;
        if (i == 0) {
            model.cover = @"";
        }else if (i == 1){
            model.cover = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg";
            
        }else if (i % 2 == 0){
            model.cover = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg";
        }
        model.title = @"我的收藏支部动态测试数据我的收藏支部动态测试数据我的收藏支部动态测试数据我的收藏支部动态测试数据";
        [arrmu addObject:model];
    }
    self.dataArray = arrmu.copy;
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.offset = 0;
//        [self.tableView.mj_footer resetNoMoreData];
//        [self getData];
//    }];
//
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self getData];
//    }];
}

- (void)getData{
//    [DJDiscoveryNetworkManager.sharedInstance frontBranch_selectWithOffset:self.offset success:^(id responseObj) {
//
//        NSArray *array = responseObj;
//
//        if (self.offset == 0) {
//            [self.tableView.mj_footer resetNoMoreData];
//            [self.tableView.mj_header endRefreshing];
//        }
//
//        if (array == nil || array.count == 0) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            return;
//        }else{
//            [self.tableView.mj_footer endRefreshing];
//
//
//            NSMutableArray *arrmu;
//            if (self.offset == 0) {
//                arrmu = NSMutableArray.new;
//            }else{
//                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
//            }
//            for (NSInteger i = 0; i < array.count; i++) {
//                DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:array[i]];
//                [arrmu addObject:model];
//            }
//            self.dataArray = arrmu.copy;
//            self.offset = self.dataArray.count;
//
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self.tableView reloadData];
//            }];
//        }
//
//    } failure:^(id failureObj) {
//        [self.tableView.mj_footer endRefreshing];
//
//    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSubPartStateModel *branchCollectModel = self.dataArray[indexPath.row];
    DCSubPartStateBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DCSubPartStateBaseCell cellReuseIdWithModel:branchCollectModel]];
    cell.delegate = self;
    cell.branchCollectModel = branchCollectModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /// 编辑状态 
    
    /// 普通状态
//    DCSubPartStateModel *model = self.dataArray[indexPath.row];
//    DCSubPartStateDetailViewController *dvc = [DCSubPartStateDetailViewController new];
//    dvc.model = model;
//    [self.navigationController pushViewController:dvc animated:YES];
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
- (void)branchCommentWithModel:(DCSubPartStateModel *)model sender:(UIButton *)sender{
    /// 跳转到详情页面，并弹出评论
    DCSubPartStateDetailViewController *dvc = [DCSubPartStateDetailViewController new];
    dvc.model = model;
    dvc.showCommentView = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
