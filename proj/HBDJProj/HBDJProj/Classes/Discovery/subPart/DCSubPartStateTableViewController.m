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

@interface DCSubPartStateTableViewController ()
@property (assign,nonatomic) NSInteger offset;

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
    [self.tableView registerNib:[UINib nibWithNibName:oneImgCell bundle:nil]
         forCellReuseIdentifier:oneImgCell];
    [self.tableView registerNib:[UINib nibWithNibName:threeImgCell bundle:nil]
         forCellReuseIdentifier:threeImgCell];
    
//    NSMutableArray *arrMu = [NSMutableArray arrayWithCapacity:10];
//    for (NSInteger i = 0; i < 20; i++) {
//        DCSubPartStateModel *model = [DCSubPartStateModel new];
//        NSInteger num = arc4random_uniform(3) + 1;/// 1 2 3
//        if (num == 2) {
//            num -= 2;/// 2 --> 0
//        }
//        model.imgCount = num;
//        [arrMu addObject:model];
//    }
//    self.dataArray = arrMu.copy;
//    [self.tableView reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
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
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSubPartStateDetailViewController *dvc = [DCSubPartStateDetailViewController new];
    [self.navigationController pushViewController:dvc animated:YES];
}


@end
