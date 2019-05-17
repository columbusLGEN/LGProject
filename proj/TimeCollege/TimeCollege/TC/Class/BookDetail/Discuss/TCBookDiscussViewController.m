//
//  TCBookDiscussViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/25.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookDiscussViewController.h"
#import "TCInputDiscussView.h"
#import "TCBookDiscussTableViewCell.h"
#import "YNPageTableView.h"

static NSString *disCell = @"TCBookDiscussTableViewCell";

@interface TCBookDiscussViewController ()

@end

@implementation TCBookDiscussViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:disCell bundle:nil] forCellReuseIdentifier:disCell];
    
    TCInputDiscussView *commitv = [TCInputDiscussView inputDiscussv];
    commitv.frame = CGRectMake(0, 0, Screen_Width, 220);
    commitv.model = NSObject.new;
    self.tableView.tableHeaderView = commitv;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCBookDiscussTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:disCell forIndexPath:indexPath];
    cell.model = [NSObject new];
    return cell;
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
