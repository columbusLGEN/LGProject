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

static NSString * const cellID = @"UCQuestionTableViewCell";

@interface DCQuestionCommunityViewController ()<
UCQuestionTableViewCellDelegate>
@property (assign,nonatomic) NSInteger offset;

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


@end
