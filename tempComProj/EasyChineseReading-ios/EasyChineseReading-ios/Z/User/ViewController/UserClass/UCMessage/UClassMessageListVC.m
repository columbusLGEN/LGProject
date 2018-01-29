//
//  UCMessageListVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UClassMessageListVC.h"

#import "UCMessageListTableViewCell.h"

#import "UCImpowerManagerVC.h"
#import "UClassMessageDetailVC.h"

@interface UClassMessageListVC () <UITableViewDelegate, UITableViewDataSource>

/* 数据源 */
@property (strong, nonatomic) NSMutableArray *arrDataSource;
@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger currentPage; // 当前页

@property (strong, nonatomic) EmptyView *emptyView;

@end

@implementation UClassMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self showWaitTips];
    [self getFirstPageDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"站内信");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_class_message_white"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedUser)];
}

- (void)configView
{
    [self configTableView];
    [self configMJRefresh];
    [self configEmptyView];
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = _arrDataSource.count > 0;
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCMessageListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCMessageListTableViewCell class])];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getFirstPageDataSource];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself getDataSourceWithPage:_currentPage];
    }];
}

#pragma mark - 获取数据

- (void)getFirstPageDataSource
{
    _currentPage = 0;
    WeakSelf(self)
    [[ClassRequest sharedInstance] getMessagesWithPage:_currentPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrDataSource = [SendMessageModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrDataSource.count > 0) {
                self.currentPage += 1;
            }
            self.emptyView.hidden = self.arrDataSource.count > 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getDataSourceWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] getMessagesWithPage:page length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [SendMessageModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentPage += 1;
                [self.arrDataSource addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCMessageListTableViewCell class])];
    
    cell.data = _arrDataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UClassMessageDetailVC *detail = [UClassMessageDetailVC new];
    detail.message = _arrDataSource[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 选择用户
    
- (void)selectedUser
{
    UCImpowerManagerVC *selectedUser = [UCImpowerManagerVC new];
    selectedUser.toMessage = YES;
    [self.navigationController pushViewController:selectedUser animated:YES];
}

#pragma mark - 属性

- (NSMutableArray *)arrDataSource
{
    if (_arrDataSource == nil) {
        _arrDataSource = [NSMutableArray array];
    }
    return _arrDataSource;
}

@end
