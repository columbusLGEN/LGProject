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

@interface OLVoteListController ()

@end

@implementation OLVoteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 79;
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    NSMutableArray *arrMu = [NSMutableArray new];
    for (NSInteger i = 0; i < 10; i++) {
        OLVoteListModel *model = [OLVoteListModel new];
        model.title = @"2017年十大党建活动";
        model.title = @"2018-1-6";
        model.isVote = (arc4random_uniform(2) == 1);
        model.isEnd = (arc4random_uniform(2) == 1);
        [arrMu addObject:model];
    }
    self.dataArray = arrMu.copy;
    [self.tableView reloadData];
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
    OLVoteDetailController *vc = [OLVoteDetailController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
