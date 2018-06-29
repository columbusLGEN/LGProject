//
//  UCPersonInfoViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPersonInfoViewController.h"
#import "UCPersonInfoModel.h"
#import "UCPersonInfoTableViewCell.h"

@interface UCPersonInfoViewController ()
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCPersonInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    self.title = @"个人信息";
//    _array = [UCPersonInfoModel loadLocalPlistWithPlistName:@"userInfoConfig"];
    _array = [UCPersonInfoModel userInfoArray];
//    NSLog(@"array: %@",_array);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCPersonInfoModel *model = _array[indexPath.row];
    UCPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCPersonInfoTableViewCell cellReuseIdWithModel:model]];
    cell.model = model;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}



@end
