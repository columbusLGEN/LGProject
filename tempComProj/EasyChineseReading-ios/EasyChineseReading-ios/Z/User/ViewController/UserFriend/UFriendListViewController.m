//
//  UFriendListViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UFriendListViewController.h"

#import "UFriendListTableViewCell.h"

#import "UFriendAddVC.h"
#import "UFriendInfoVC.h"

#import "ECRBookInfoViewController.h"

@interface UFriendListViewController () <UITableViewDelegate, UITableViewDataSource, UFriendListTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrDataSource;// 好友列表
@property (strong, nonatomic) NSMutableArray *arrFriendIds; // 好友 id 列表

@property (strong, nonatomic) EmptyView *emptyView;

@end

@implementation UFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHeaderView];
    [self configTableView];
    [self addEmptyView];
    [self getFriendsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)configHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnAddFriend = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 120 - 20, 5, 120, cHeaderHeight_44 - 5*2)];
    btnAddFriend.titleLabel.font = [UIFont systemFontOfSize:14.f];
    btnAddFriend.backgroundColor = [UIColor cm_orangeColor_FFAF04_1];
    [btnAddFriend setImage:[UIImage imageNamed:@"icon_friend_add_white"] forState:UIControlStateNormal];
    [btnAddFriend setImage:[UIImage imageNamed:@"icon_friend_add_white"] forState:UIControlStateHighlighted];
    [btnAddFriend setTitle:LOCALIZATION(@"添加好友") forState:UIControlStateNormal];
    [btnAddFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAddFriend addTarget:self action:@selector(addFriendHandle) forControlEvents:UIControlEventTouchUpInside];
    
    // 切掉背景的右上角, 左下角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:btnAddFriend.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = btnAddFriend.bounds;
    maskLayer.path = path.CGPath;
    btnAddFriend.layer.mask = maskLayer;
    
    [headerView addSubview:btnAddFriend];
    [self.view addSubview:headerView];
}

- (void)configTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, Screen_Height - 2*cHeaderHeight_44 - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UFriendListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UFriendListTableViewCell class])];
}

- (void)addEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, cHeaderHeight_44, self.view.width, self.view.height - cHeaderHeight_44)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeFriend Image:nil desc:nil subDesc:nil backgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = YES;
}

#pragma mark - 添加好友
- (void)addFriendHandle
{
    UFriendAddVC *friendInfo = [UFriendAddVC loadFromStoryBoard:@"User"];
    friendInfo.addFriendSuccess = ^(FriendModel *user) {
        [_arrDataSource addObject:user];
        [_arrFriendIds addObject:@(user.userId)];
        [[CacheDataSource sharedInstance] setCache:_arrDataSource withCacheKey:CacheKey_FriendsList];
        [[CacheDataSource sharedInstance] setCache:_arrFriendIds withCacheKey:CacheKey_FriendIdsList];
        _emptyView.hidden = YES;
        [_tableView reloadData];
    };
    friendInfo.delFriendSuccess = ^(FriendModel *user) {
        [self deleteFriendHandleWithFriend:user];
        [_tableView reloadData];
        _emptyView.hidden = _arrDataSource.count > 0;
    };
    [self.navigationController pushViewController:friendInfo animated:YES];
}

#pragma mark - 获取好友列表
- (void)getFriendsData
{
    [self showWaitTips];
    WeakSelf(self)
    [[FriendRequest sharedInstance] getFriendListWithUserName:@"" completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            _arrDataSource = [FriendModel mj_objectArrayWithKeyValuesArray:object];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                _arrFriendIds = [NSMutableArray array];
                [_arrDataSource enumerateObjectsUsingBlock:^(FriendModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_arrFriendIds addObject:@(obj.userId)];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _emptyView.hidden = _arrDataSource.count > 0;
                    [[CacheDataSource sharedInstance] setCache:_arrDataSource withCacheKey:CacheKey_FriendsList];
                    [[CacheDataSource sharedInstance] setCache:_arrFriendIds withCacheKey:CacheKey_FriendIdsList];
                    [_tableView reloadData];
                });
            });
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
    UFriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UFriendListTableViewCell class])];
    cell.delegate = self;
    cell.data = _arrDataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self toFriendInfoWithFriend:_arrDataSource[indexPath.row]];
}

#pragma mark - UFriendListNewTableViewCellDelegate

/** 添加好友 */
- (void)addFriendWithFriend:(FriendModel *)user
{
    
}

/** 删除好友 */
- (void)delFriendWithFriend:(FriendModel *)user
{
    [self delFriendWithFriend:user indexPath:nil];
}

/** 查看好友详情 */
- (void)toFriendInfoWithFriend:(FriendModel *)user
{
    FriendModel *friend = user;
    UFriendInfoVC *frinendInfo = [UFriendInfoVC loadFromStoryBoard:@"User"];
    frinendInfo.friendInfo = friend;
    [self.navigationController pushViewController:frinendInfo animated:YES];
}

#pragma mark - 删除好友
/** 删除好友 */
- (void)delFriendWithFriend:(FriendModel *)user indexPath:(NSIndexPath *)indexPath
{
    WeakSelf(self)
    [[FriendRequest sharedInstance] delFriendWithFriendId:user.userId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            [self deleteFriendHandleWithFriend:user];
            if (indexPath)
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            else
                [self.tableView reloadData];
        }
    }];
}

/** 删除当前界面好友及缓存 */
- (void)deleteFriendHandleWithFriend:(FriendModel *)user
{
    if ([_arrDataSource containsObject:user]) {
        [_arrDataSource removeObject:user];
        [[CacheDataSource sharedInstance] setCache:_arrDataSource withCacheKey:CacheKey_FriendsList];
    }
    if ([_arrFriendIds containsObject:@(user.userId)]) {
        [_arrFriendIds removeObject:@(user.userId)];
        [[CacheDataSource sharedInstance] setCache:_arrFriendIds withCacheKey:CacheKey_FriendIdsList];
    }
}

#pragma mark - 属性

- (NSMutableArray *)arrDataSource
{
    if (_arrDataSource == nil) {
        _arrDataSource = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_FriendsList];
    }
    return _arrDataSource;
}

@end
