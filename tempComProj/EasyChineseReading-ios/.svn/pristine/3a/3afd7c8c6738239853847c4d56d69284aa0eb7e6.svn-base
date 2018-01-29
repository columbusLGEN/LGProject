//
//  UFriendDynamicViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UFriendDynamicViewController.h"

#import "UFriendDynamicTableViewCell.h"
#import "UFriendReadTableViewCell.h"
#import "UFriendReadPadTableViewCell.h"

#import "ECRBookInfoViewController.h"
#import "UFriendInfoVC.h"

@interface UFriendDynamicViewController () <
UITableViewDelegate, UITableViewDataSource,
UFriendDynamicTableViewCellDelegate,
UFriendReadTableViewCellDelegate,
UFriendReadPadTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrDataSource;

@property (strong, nonatomic) EmptyView *emptyView;

@property (assign, nonatomic) NSInteger currentPage; // 当前页数

@end

@implementation UFriendDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self addEmptyView];
    [self configMJRefresh];
    [self showWaitTips];
    [self getFirstPageDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置动态界面

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

/** 获取第一页动态列表数据 */
- (void)getFirstPageDataSource
{
    _currentPage = 0;
    WeakSelf(self)
    [[FriendRequest sharedInstance] getDynamicsWithPage:[NSString stringWithFormat:@"%ld", _currentPage]
                                                 length:[NSString stringWithFormat:@"%ld", cListNumber_10]
                                               friendId:@""
                                             completion:^(id object, ErrorModel *error) {
                                                 StrongSelf(self)
                                                 [self.tableView.mj_header endRefreshing];
                                                 [self dismissTips];
                                                 if (error) {
                                                     [self presentFailureTips:error.message];
                                                 }
                                                 else {
                                                     self.arrDataSource = [DynamicModel mj_objectArrayWithKeyValuesArray:object];
                                                     if (self.arrDataSource.count > 0) {
                                                         self.currentPage += 1;
                                                     }
                                                     self.emptyView.hidden = self.arrDataSource.count > 0;
                                                     [self.tableView reloadData];
                                                 }
                                             }];
}

/**
 加载更多好友动态列表

 @param page 页数
 */
- (void)getDataSourceWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[FriendRequest sharedInstance] getDynamicsWithPage:[NSString stringWithFormat:@"%ld", _currentPage]
                                                 length:[NSString stringWithFormat:@"%ld", cListNumber_10]
                                               friendId:@""
                                             completion:^(id object, ErrorModel *error) {
                                                 StrongSelf(self)
                                                 [self.tableView.mj_footer endRefreshing];
                                                 if (error) {
                                                     [self presentFailureTips:error.message];
                                                 }
                                                 else {
                                                     NSArray *array = [DynamicModel mj_objectArrayWithKeyValuesArray:object];
                                                     if (array.count > 0) {
                                                         self.currentPage += 1;
                                                         [self.arrDataSource addObjectsFromArray:array];
                                                         self.emptyView.hidden = YES;
                                                         [self.tableView reloadData];
                                                     }
                                                 }
                                             }];
}

- (void)configTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_64 - cHeaderHeight_44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // tableView 自适应高度
    self.tableView.estimatedRowHeight = 210;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UFriendDynamicTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UFriendDynamicTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UFriendReadTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UFriendReadTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UFriendReadPadTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UFriendReadPadTableViewCell class])];
}

- (void)addEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:self.view.bounds];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeUnknow Image:nil desc:LOCALIZATION(@"还没有朋友发布动态") subDesc:nil backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicModel *dynamic = _arrDataSource[indexPath.row];
    if (dynamic.bookId > 0) {
        UFriendDynamicTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UFriendDynamicTableViewCell class])];
        dynamicCell.delegate = self;
        dynamicCell.data = dynamic;
        return dynamicCell;
    }
    else {
        if (isPad) {
            UFriendReadPadTableViewCell *readInfocell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UFriendReadPadTableViewCell class])];
            readInfocell.delegate = self;
            readInfocell.data = dynamic;
            return readInfocell;
        }
        else {
            UFriendReadTableViewCell *readInfocell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UFriendReadTableViewCell class])];
            readInfocell.delegate = self;
            readInfocell.data = dynamic;
            return readInfocell;
        }
    }
}

#pragma mark - UFriendDynamicTableViewCellDelegate

/**
 进入详情页面

 @param bookId 图书id
 */
- (void)toBookDetailWithBookId:(NSInteger)bookId
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = bookId;
    [self.navigationController pushViewController:bivc animated:YES];
}

/**
 查看好友详情

 @param friendInfo 好友模型
 */
- (void)toFriendInfoWithFriend:(FriendModel *)friendInfo
{
    UFriendInfoVC *frinendInfo = [UFriendInfoVC loadFromStoryBoard:@"User"];
    frinendInfo.friendInfo = friendInfo;
    [self.navigationController pushViewController:frinendInfo animated:YES];
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
