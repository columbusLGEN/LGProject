//
//  EDJMicroPartyLessionViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessionViewController.h"
#import <MJRefresh.h>

static NSString * const testCell = @"testCell";

@interface EDJMicroPartyLessionViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong,nonatomic) NSMutableArray *array;
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation EDJMicroPartyLessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor randomColor];
    
    _array = [NSMutableArray arrayWithObjects:@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a",@"a", nil];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        for (NSInteger i = 0; i < 10; i++) {
            [_array addObject:@"a"];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"offsetY -- %f",scrollView.contentOffset.y);
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testCell];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@_%ld",_array[indexPath.row],indexPath.row]];
    return cell;
}

/// MARK: lazy load
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCell];
    }
    return _tableView;
}

@end
