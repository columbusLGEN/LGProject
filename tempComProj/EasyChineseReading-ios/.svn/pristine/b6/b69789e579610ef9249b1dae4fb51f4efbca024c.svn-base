//
//  UCReadDetailVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCReadDetailVC.h"

#import "UCReadDetailTableViewCell.h"

#import "UCRDetailStudentVC.h"

@interface UCReadDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *arrDataSource;

@property (strong, nonatomic) EmptyView *emptyView;

@end

@implementation UCReadDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configReadDetailView];
    [self getReadDetail];
    [self configEmptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)configReadDetailView
{
    self.title = _classInfo.className;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_44 - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCReadDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCReadDetailTableViewCell class])];
}


- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = _arrDataSource.count > 0;
}

#pragma mark - 获取数据

- (void)getReadDetail
{
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] getReadingProgressWithClassId:_classInfo.classId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrDataSource = [FriendModel mj_objectArrayWithKeyValuesArray:object];
            [self.tableView reloadData];
            self.emptyView.hidden = self.arrDataSource.count > 0;
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCReadDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCReadDetailTableViewCell class])];
    cell.data = _arrDataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_arrDataSource.count > 0) {
        FriendModel *student = _arrDataSource[indexPath.row];
        UCRDetailStudentVC *studentDetail = [[UCRDetailStudentVC alloc] init];
        studentDetail.student = student;
        [self.navigationController pushViewController:studentDetail animated:YES];
    }
}

@end
