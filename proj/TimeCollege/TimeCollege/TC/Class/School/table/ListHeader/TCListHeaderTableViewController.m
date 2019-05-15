//
//  TCListHeaderTableViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCListHeaderTableViewController.h"
#import "TCBookCatagoryLineModel.h"
#import "TCListHeaderTableViewCell.h"

@interface TCListHeaderTableViewController ()

@end

@implementation TCListHeaderTableViewController

@synthesize array = _array;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    /// 注册cell
    [self.tableView registerClass:[TCListHeaderTableViewCell class] forCellReuseIdentifier:lhtCell];
    
    /// 假数据
//    self.array = [TCBookCatagoryLineModel loadLocalPlistWithPlistName:@"fenleiTest"];
//    [self.tableView reloadData];
    
}

- (void)setArray:(NSArray *)array{
    _array = array;
    [self.tableView reloadData];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBookCatagoryLineModel *lineModel = self.array[indexPath.row];
    
    TCListHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lhtCell forIndexPath:indexPath];
    
    cell.model = lineModel;
    
    return cell;
}


@end
