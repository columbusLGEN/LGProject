//
//  UCRecommendVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendListVC.h"

#import "UClassRecommendTableViewCell.h"
#import "UClassImpowerTableViewCell.h"

#import "UCRecommendDetailVC.h"

@interface UCRecommendListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrRecommendList;    // 推荐的数组
@property (strong, nonatomic) NSMutableArray *arrImpoverList;      // 授权数组

@property (assign, nonatomic) NSInteger currentRecommendListPage; // 推荐当前页
@property (assign, nonatomic) NSInteger currentImpowerListPage;   // 授权当前页

@property (strong, nonatomic) EmptyView *emptyView;

@end

@implementation UCRecommendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self showWaitTips];
    if (_recommendType == ENUM_RecommendTypeRecommend)
        [self getFirstPageRecommendList];
    else
        [self getFirstPageImpowerList];
}

#pragma mark - 配置界面

- (void)configView
{
    [self configTableView];
    [self configMJRefresh];
    [self configEmptyView];
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationReloadRecommends usingBlock:^(NSNotification *note) {
        [weakself getFirstPageRecommendList];
    }];
    [self fk_observeNotifcation:kNotificationReloadImpowers usingBlock:^(NSNotification *note) {
        [weakself getFirstPageImpowerList];
    }];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_44 - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UClassRecommendTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UClassRecommendTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UClassImpowerTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UClassImpowerTableViewCell class])];
    
    [self.view addSubview:_tableView];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(self)
        if (_recommendType == ENUM_RecommendTypeRecommend)
            [self getFirstPageRecommendList];
        else
            [self getFirstPageImpowerList];
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        StrongSelf(self)
        if (_recommendType == ENUM_RecommendTypeRecommend)
            [self getRecommendListWithPage:_currentRecommendListPage];
        else
            [self getImpowerListPage:_currentImpowerListPage];
    }];
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
}

#pragma mark - 获取数据
/** 推荐首页数据 */
- (void)getFirstPageRecommendList
{
    _currentRecommendListPage = 0;
    WeakSelf(self)
    [[ClassRequest sharedInstance] getRecommendListWithPage:_currentRecommendListPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrRecommendList  = [RecommendModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrRecommendList.count > 0) {
                self.currentRecommendListPage += 1;
                self.emptyView.hidden = YES;
            }
            [self.tableView reloadData];
        }
    }];
}

/** 根据页码获取推荐列表数据 */
- (void)getRecommendListWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] getRecommendListWithPage:page length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [RecommendModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentRecommendListPage += 1;
                [self.arrRecommendList addObjectsFromArray:array];
                self.emptyView.hidden = YES;
                [self.tableView reloadData];
            }
        }
    }];
}

/** 授权首页数据 */
- (void)getFirstPageImpowerList
{
    _currentImpowerListPage = 0;
    WeakSelf(self)
    [[ClassRequest sharedInstance] getImpowerListWithPage:_currentImpowerListPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrImpoverList = [ImpowerModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrImpoverList.count > 0) {
                self.emptyView.hidden = YES;
                self.currentImpowerListPage += 1;
            }
            [self.tableView reloadData];
        }
    }];
}

/** 根据页码获取授权列表数据 */
- (void)getImpowerListPage:(NSInteger)page
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] getImpowerListWithPage:page length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [ImpowerModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentImpowerListPage += 1;
                self.emptyView.hidden = YES;
                [self.arrImpoverList addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recommendType == ENUM_RecommendTypeRecommend ? _arrRecommendList.count : _arrImpoverList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_recommendType == ENUM_RecommendTypeRecommend) {
        UClassRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UClassRecommendTableViewCell class])];
        cell.data = _arrRecommendList[indexPath.row];
        return cell;
    }
    else {
        UClassImpowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UClassImpowerTableViewCell class])];
        cell.data = _arrImpoverList[indexPath.row]; 
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCRecommendDetailVC *detailVC = [[UCRecommendDetailVC alloc] init];
    
    detailVC.recommendType = _recommendType;
    detailVC.userType      = [UserRequest sharedInstance].user.userType;
    detailVC.recommend     = _arrRecommendList[indexPath.row];
    detailVC.impower       = _arrImpoverList[indexPath.row];
    
    WeakSelf(self)
    detailVC.cancelImpower = ^(ImpowerModel *impower) {
        StrongSelf(self)
        [self.arrImpoverList removeObject:self.arrImpoverList[indexPath.row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -

- (NSMutableArray *)arrRecommendList
{
    if (_arrRecommendList == nil) {
        _arrRecommendList = [NSMutableArray array];
    }
    return _arrRecommendList;
}

- (NSMutableArray *)arrImpoverList
{
    if (_arrImpoverList == nil) {
        _arrImpoverList = [NSMutableArray array];
    }
    return _arrImpoverList;
}

@end
