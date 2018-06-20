//
//  HPBuildTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBuildTableViewController.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"

#import "LGDidSelectedNotification.h"
#import "LTScrollView-Swift.h"

@interface HPBuildTableViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@end

@implementation HPBuildTableViewController

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = _dataArray[indexPath.row];
    EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroBuildCell cellHeightWithModel:self.dataArray[indexPath.row]];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    NSDictionary *dict = @{LGDidSelectedModelKey:model,
                           LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeBuildNews),
                           LGDidSelectedIndexKey:@(indexPath.row)
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];

    self.glt_scrollView = self.tableView;
    
    /// EDJMicroBuildCell
    [self.tableView registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.superVc refreshingAction:@selector(buildPointNewsLoadMoreDatas)];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - kTabBarHeight - kNavHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
