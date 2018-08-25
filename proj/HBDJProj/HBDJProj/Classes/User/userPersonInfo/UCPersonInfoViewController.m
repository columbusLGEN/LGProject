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
    _array = [UCPersonInfoModel userInfoArray];
    [self.tableView reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUserinfo)];
}

- (void)getUserinfo{
    [DJUserNetworkManager.sharedInstance frontUserinfo_selectSuccess:^(id responseObj) {
        [self.tableView.mj_header endRefreshing];
        DJUser *user = [DJUser mj_objectWithKeyValues:responseObj];
        
        /// 用户信息本地化
        [user keepUserInfo];
        
        /// 将本地用户信息赋值给单利对象,保证每次用户重新登录之后，都会重新赋值
        [[DJUser sharedInstance] getLocalUserInfo];
        
        _array = [UCPersonInfoModel userInfoArray];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
        
    } failure:^(id failureObj) {
        [self.tableView.mj_header endRefreshing];
    }];
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
