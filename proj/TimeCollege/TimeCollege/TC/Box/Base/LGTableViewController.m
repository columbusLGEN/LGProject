//
//  LGTableViewController.m
//  youbei
//
//  Created by Peanut Lee on 2019/2/28.
//  Copyright © 2019 libc. All rights reserved.
//

#import "LGTableViewController.h"
#import "YNPageTableView.h"

@interface LGTableViewController ()

@end

@implementation LGTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self headerRefresh];
    
}

- (void)headerRefresh{
    self.currentPage = 0;
    self.array = nil;
    
}
- (void)footerRefresh{
    
}

- (void)stopRefreshAnimate{
    if (self.currentPage == 0) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
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
