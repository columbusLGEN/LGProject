//
//  EDJTodayScoreViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJTodayScoreViewController.h"
#import "view/EDJTotayScoreTableViewCell.h"
#import "EDJLevelInfoModel.h"

static NSString * const cellID = @"EDJTotayScoreTableViewCell";

@interface EDJTodayScoreViewController ()<
UITableViewDelegate>

@end

@implementation EDJTodayScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日加分";
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
}

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJLevelInfoModel *model = self.dataArray[indexPath.row];
    EDJTotayScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


@end
