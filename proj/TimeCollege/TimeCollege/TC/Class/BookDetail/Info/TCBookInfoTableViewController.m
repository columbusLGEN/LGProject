//
//  TCBookInfoTableViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookInfoTableViewController.h"
#import "TCBookInfoCell.h"
#import "TCBIRecoCell.h"
#import "TCBIContentCell.h"
#import "TCBIMessageCell.h"
#import "TCBookInfoRecoCollectionViewController.h"
#import "YNPageTableView.h"

static NSString *testcell = @"testcell";

@interface TCBookInfoTableViewController ()
@property (strong,nonatomic) TCBookInfoRecoCollectionViewController *recovc;

@end

@implementation TCBookInfoTableViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)conShowAll:(UIButton *)sender{
    /// TODO: 显示全部 or 显示部分（默认5行）
    [self.tableView reloadData];
}

- (void)configUI{
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
//    self.tableView.rowHeight = 200;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testcell];
    
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerClass:[TCBIMessageCell class] forCellReuseIdentifier:BIMSGcell];
    [self.tableView registerClass:[TCBIContentCell class] forCellReuseIdentifier:BICTTcell];
    [self.tableView registerClass:[TCBIRecoCell class] forCellReuseIdentifier:BIRCcell];
    
    self.recovc = TCBookInfoRecoCollectionViewController.new;
    [self addChildViewController:self.recovc];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBookInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[TCBookInfoCell cellReuseIdWith:indexPath] forIndexPath:indexPath];
    cell.fatherTableView = tableView;
//    if ([cell isKindOfClass:[TCBIContentCell class]]) {
//        TCBIContentCell *contentCell = (TCBIContentCell *)cell;
//        [contentCell.showAll addTarget:self action:@selector(conShowAll:) forControlEvents:UIControlEventTouchUpInside];
//    }
    if ([cell isKindOfClass:[TCBIRecoCell class]]) {
        TCBIRecoCell *recocell = (TCBIRecoCell *)cell;
        recocell.recovc = self.recovc;
    }
    cell.model = @"test";
    return cell;
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testcell forIndexPath:indexPath];
//    cell.contentView.backgroundColor = UIColor.randomColor;
//    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [YNPageTableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        
        
    }
    return _tableView;
}

@end
