//
//  TCSchoolBookTableViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCSchoolBookTableViewController.h"
#import "TCSchoolBookTableViewCell.h"
#import "TCBookDetailManagerController.h"

static NSString * const sbTableViewCell = @"TCSchoolBookTableViewCell";

@interface TCSchoolBookTableViewController ()

@end

@implementation TCSchoolBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:sbTableViewCell bundle:nil] forCellReuseIdentifier:sbTableViewCell];
    
//    self.tableView.mj_header = nil;
//    self.tableView.mj_footer = nil;
}

// MARK: 接收数据
- (void)setArray:(NSArray *)array{
    [super setArray:array];
    
}

- (void)headerRefresh{
    [super headerRefresh];
    // MARK: 获取数据(下拉刷新)
    
    
    [self stopRefreshAnimate];
}
- (void)footerRefresh{
    self.currentPage += 1;
    // MARK: 上拉获取数据
    [self stopRefreshAnimate];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCSchoolBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sbTableViewCell forIndexPath:indexPath];
    cell.index = indexPath;
    [cell index:indexPath firstCellHiddenLine:self.firstCellHiddenLine];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBookDetailManagerController *bdvc = [TCBookDetailManagerController new];
//    bdvc.detailType = 2;
    [self.navigationController pushViewController:bdvc animated:YES];
}

@end
