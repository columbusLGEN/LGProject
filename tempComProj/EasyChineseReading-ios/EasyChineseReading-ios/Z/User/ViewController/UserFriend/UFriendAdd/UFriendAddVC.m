//
//  UFriendAddVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UFriendAddVC.h"

#import "UFriendListTableViewCell.h"
#import "UFriendInfoVC.h"

@interface UFriendAddVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UFriendListTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtfSearch;

@property (assign, nonatomic) NSInteger currentPage; // 当前页

@property (assign, nonatomic) BOOL searchState;      // 搜索状态

@property (strong, nonatomic) NSMutableArray *arrRecommend;   // 推荐的好友

@property (strong, nonatomic) NSArray *arrFriendIds;          // 我的好友 id
@property (strong, nonatomic) NSArray *arrSearchs;            // 搜索的好友

@property (strong, nonatomic) EmptyView *emptyView;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation UFriendAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchState = NO;
    [self configAddFriend];
    [self configMJRefresh];
    [self showWaitTips];
    [self getFirstPageRecommendFriends];
    [self addEmptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"添加好友");
    _txtfSearch.placeholder = LOCALIZATION(@"搜索好友(请输入好友账号)");
    [_tableView reloadData];
}

#pragma mark - 配置界面

- (void)configAddFriend
{
    self.view.backgroundColor = [UIColor whiteColor];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [self registerTableView];
    [self configSearchBar];
}

- (void)configSearchBar
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
    _txtfSearch.leftView = imageView;
    _txtfSearch.leftViewMode = UITextFieldViewModeAlways;
    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btnClear setImage:[UIImage imageNamed:@"icon_friend_search_close"] forState:UIControlStateNormal];
    [btnClear setImage:[UIImage imageNamed:@"icon_friend_search_close"] forState:UIControlStateHighlighted];
    [btnClear addTarget:self action:@selector(clearSearchText) forControlEvents:UIControlEventTouchUpInside];
    _txtfSearch.rightView = btnClear;
    _txtfSearch.rightViewMode = UITextFieldViewModeAlways;

    _txtfSearch.layer.cornerRadius  = _txtfSearch.height/2;
    _txtfSearch.layer.masksToBounds = YES;
}

- (void)addEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, cHeaderHeight_64 + cHeaderHeight_54, self.view.width, self.view.height - cHeaderHeight_64 - cHeaderHeight_54)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeSearch Image:nil desc:nil subDesc:nil backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_emptyView];
}

- (void)registerTableView
{
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UFriendListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UFriendListTableViewCell class])];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(self)
        if (self.searchState == NO) {
            [self getFirstPageRecommendFriends];
        }
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        StrongSelf(self)
        if (self.searchState == NO) {
            [self getRecommendFriendsWithPage:_currentPage];
        }
    }];
}

#pragma mark - 获取推荐好友

- (void)getFirstPageRecommendFriends
{
    _currentPage = 0;
    WeakSelf(self)
    [[FriendRequest sharedInstance] getRecommendFriendsWithPage:_currentPage length:cListNumber_10 * 2 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            _arrRecommend = [FriendModel mj_objectArrayWithKeyValuesArray:object];
            if (_arrRecommend.count > 0) {
                _currentPage += 1;
            }
            [_tableView reloadData];
        }
        _emptyView.hidden = _arrRecommend.count > 0;
    }];
}

- (void)getRecommendFriendsWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[FriendRequest sharedInstance] getRecommendFriendsWithPage:page length:cListNumber_10 * 2 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [_tableView.mj_footer endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [FriendModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                _currentPage += 1;
                [_arrRecommend addObjectsFromArray:array];
                [_tableView reloadData];
            }
        }
    }];
}

/**
 精确搜索，根据账号获取用户信息

 @param account 账号（手机号，邮箱号）
 */
- (void)getFriendWithAccount:(NSString *)account
{
    WeakSelf(self)
    [[FriendRequest sharedInstance] getFriendListWithUserName:account completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            _arrRecommend = [FriendModel mj_objectArrayWithKeyValuesArray:object];
            _emptyView.hidden = _arrRecommend.count > 0;
            [_tableView reloadData];
        }
    }];
}

- (void)tapBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchState ? _arrSearchs.count : _arrRecommend.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UFriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UFriendListTableViewCell class])];
    cell.delegate = self;
    cell.data = _searchState ? _arrSearchs[indexPath.row] : _arrRecommend[indexPath.row];
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchState = YES;
    [_txtfSearch resignFirstResponder];
    WeakSelf(self)
    [[FriendRequest sharedInstance] getFriendListWithUserName:textField.text completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrSearchs = [FriendModel mj_objectArrayWithKeyValuesArray:object];
            self.emptyView.hidden = self.arrSearchs.count > 0;
            [self.tableView reloadData];
        }
    }];
    return YES;
}

- (void)textDidChange
{
    if (_searchState == NO && _txtfSearch.text.length > 0) {
        _searchState = YES;
        _arrSearchs = @[];
        [_tableView reloadData];
    }
}

#pragma mark - UFriendAddTableViewCellDelegate

/**
 添加好友

 @param user 用户信息
 */
- (void)addFriendWithFriend:(FriendModel *)user
{
    WeakSelf(self)
    [[FriendRequest sharedInstance] addFriendWithFriendId:user.userId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.addFriendSuccess(user);
            self.arrFriendIds = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_FriendIdsList];
        }
    }];
}

/** 删除好友信息 */
- (void)delFriendWithFriend:(FriendModel *)user
{
    WeakSelf(self)
    [[FriendRequest sharedInstance] delFriendWithFriendId:user.userId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.delFriendSuccess(user);
            self.arrFriendIds = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_FriendIdsList];
        }
    }];
}

/** 查看好友信息 */
- (void)toFriendInfoWithFriend:(FriendModel *)user
{
    UFriendInfoVC *frinendInfo = [UFriendInfoVC loadFromStoryBoard:@"User"];
    frinendInfo.friendInfo = user;
    [self.navigationController pushViewController:frinendInfo animated:YES];
}

#pragma mark - 清除正在搜索的内容，退出搜索状态

- (void)clearSearchText
{
    _searchState = NO;
    _emptyView.hidden = YES;
    _txtfSearch.text = nil;
    [_txtfSearch resignFirstResponder];
    [_tableView reloadData];
}

#pragma mark - 属性

- (NSMutableArray *)arrRecommend
{
    if (_arrRecommend == nil) {
        _arrRecommend = [NSMutableArray array];
    }
    return _arrRecommend;
}

@end
