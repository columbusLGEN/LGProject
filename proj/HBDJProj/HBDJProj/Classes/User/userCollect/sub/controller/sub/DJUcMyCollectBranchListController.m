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
#import "DJUserNetworkManager.h"
#import "DCSubPartStateOneImgCell.h"
#import "DCSubPartStateThreeImgCell.h"
#import "DJUserInteractionMgr.h"
#import "LGAlertControllerManager.h"

@interface DJUcMyCollectBranchListController ()<DCSubPartStateBaseCellDelegate>

@end

@implementation DJUcMyCollectBranchListController{
    DCSubPartStateModel *currentClickModel;
}

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
    
    [self headerFooterSet];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerFooterSet{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
}

- (void)getData{
    [DJUserNetworkManager.sharedInstance frontUserCollections_selectWithType:4 offset:self.offset success:^(id responseObj) {

        NSArray *array = responseObj;

        if (self.offset == 0) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_header endRefreshing];
        }

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
                DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:array[i]];
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
    DCSubPartStateModel *branchCollectModel = self.dataArray[indexPath.row];
    DCSubPartStateBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DCSubPartStateBaseCell cellReuseIdWithModel:branchCollectModel]];
    cell.delegate = self;
    cell.branchCollectModel = branchCollectModel;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.lg_edit) {
        /// 编辑状态
        DCSubPartStateModel *model = self.dataArray[indexPath.row];
        model.select = !model.select;
        
        if ([self.delegate respondsToSelector:@selector(ucmcCellClickWhenEdit:modelArrayCount:)]) {
            [self.delegate ucmcCellClickWhenEdit:model modelArrayCount:self.dataArray.count];
        }
        
    }else{
        /// 普通状态
        DCSubPartStateModel *model = self.dataArray[indexPath.row];
        [self navPushBranchDetailvcWithModel:model showCommentView:NO];
    }
    
}

/// 跳转到详情页面，并弹出评论
- (void)branchCommentWithModel:(DCSubPartStateModel *)model sender:(UIButton *)sender{
    [self navPushBranchDetailvcWithModel:model showCommentView:YES];
}

- (void)navPushBranchDetailvcWithModel:(DCSubPartStateModel *)model showCommentView:(BOOL)showCommentView{
    DCSubPartStateDetailViewController *dvc = [DCSubPartStateDetailViewController new];
    dvc.model = model;
    dvc.showCommentView = showCommentView;
    currentClickModel = model;
    [model addObserver:self forKeyPath:collectionidKey options:NSKeyValueObservingOptionNew context:nil];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:collectionidKey] && object == currentClickModel) {
        if (currentClickModel.collectionid == 0) {
            NSMutableArray *arrmu = [NSMutableArray arrayWithArray:self.dataArray];
            [arrmu removeObject:currentClickModel];
            self.dataArray = arrmu.copy;
            [self.tableView reloadData];

        }
    }
}

- (void)dealloc{
    if (currentClickModel) {
        [currentClickModel removeObserver:self forKeyPath:collectionidKey];
    }
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
    
    if (model.collectionid != 0) {
        UIAlertController *alertvc = [LGAlertControllerManager alertvcWithTitle:@"提示" message:@"您确定要删除此条收藏吗?" cancelText:@"取消" doneText:@"确定" cancelABlock:^(UIAlertAction * _Nonnull action) {
            sender.userInteractionEnabled = YES;
        } doneBlock:^(UIAlertAction * _Nonnull action) {
            [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:YES type:DJDataPraisetypeState success:^(NSInteger cbkid, NSInteger cbkCount) {
                sender.userInteractionEnabled = YES;
                
                NSInteger modelIndex = [self.dataArray indexOfObject:model];
                NSMutableArray *arrmu = [NSMutableArray arrayWithArray:self.dataArray];
                [arrmu removeObject:model];
                self.dataArray = arrmu.copy;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:modelIndex inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                
            } failure:^(id failureObj) {
                sender.userInteractionEnabled = YES;
                [self presentFailureTips:@"收藏失败，请稍后重试"];
            }];
        }];
        
        [self presentViewController:alertvc animated:YES completion:nil];
    }
    
    
}

- (void)startEdit{
    [super startEdit];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

- (void)endEdit{
    [super endEdit];
    [self headerFooterSet];
}

- (void)allSelect{
    [super allSelect];
    if ([self.delegate respondsToSelector:@selector(ucmcAllSelectClickWhenEdit:)]) {
        if (self.isAllSelect) {
            [self.delegate ucmcAllSelectClickWhenEdit:self.dataArray];
        }else{
            [self.delegate ucmcAllSelectClickWhenEdit:nil];
        }
    }
}

@end
