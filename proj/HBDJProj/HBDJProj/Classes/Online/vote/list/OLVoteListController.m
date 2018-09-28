//
//  OLVoteListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteListController.h"
#import "OLVoteListTableViewCell.h"
#import "OLVoteListModel.h"
#import "OLVoteDetailController.h"
#import "DJOnlineNetorkManager.h"

@interface OLVoteListController ()
@property (assign,nonatomic) NSInteger offset;

@end

@implementation OLVoteListController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];

}

- (void)configUI{
    
//    self.tableView.rowHeight = 79;
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tbHeaderRefresh)];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _offset = 0;
//        [self getNetDataWithOffset:_offset];
//    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNetDataWithOffset:_offset];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)tbHeaderRefresh{
    _offset = 0;
    [self getNetDataWithOffset:_offset];
}

- (void)getNetDataWithOffset:(NSInteger)offset{
    [DJOnlineNetorkManager.sharedInstance frontVotes_selectWithOffset:offset length:10 success:^(id responseObj) {
        NSArray *array = responseObj;
        BOOL arrayIsNull = (array == nil || array.count == 0);
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            if (arrayIsNull) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
        }
        if (arrayIsNull) {
            return;
        }else{
            NSMutableArray *arrMu;
            if (_offset == 0) {
                arrMu  = NSMutableArray.new;
            }else{
                arrMu  = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (NSInteger i = 0; i < array.count; i++) {
                OLVoteListModel *model = [OLVoteListModel mj_objectWithKeyValues:array[i]];
                [arrMu addObject:model];
            }
            
            self.dataArray = arrMu.copy;
            _offset = self.dataArray.count;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
            
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OLVoteListModel *model = self.dataArray[indexPath.row];
    OLVoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OLVoteListModel *model = self.dataArray[indexPath.row];
    OLVoteDetailController *vc = [OLVoteDetailController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79;
}

@end
