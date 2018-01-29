//
//  UserViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserViewController.h"

#import "UserCollectionHeaderView.h"
#import "UserCollectionViewCell.h"

#import "LoginVC.h"                 // 登录
#import "UserInfoVC.h"              // 用户信息
#import "UserMessageVC.h"           // 消息
#import "UserSetVC.h"               // 设置
#import "UserIntegralVC.h"          // 积分
#import "UserVirtualCurrencyVC.h"   // 虚拟币

#import "UserOrderVC.h"             // 我的订阅
#import "UserFavouriteVC.h"         // 我的收藏
#import "UserFriendManagerVC.h"     // 我的好友
#import "UserClassVC.h"             // 班级管理
#import "UserTaskVC.h"              // 我的任务
#import "USecurityCenterVC.h"       // 安全中心
#import "UserHelpVC.h"              // 使用帮助
#import "UserTicketManager.h"       // 会员中心

#import "GuideFigureImageView.h"

static CGFloat const kCellPlace = 10.f; // collectionCell间隔

@interface UserViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserCollectionHeaderViewDelegate>

@property (strong, nonatomic) UIImageView *imgNavigationBar; // 渐变nav背景
@property (strong, nonatomic) UIImageView *imgMessage;       // 消息
@property (strong, nonatomic) UIImageView *imgSet;           // 设置
@property (strong, nonatomic) UILabel     *lblTitle;         // 界面标题
@property (strong, nonatomic) UIView *alertNewMessage;       // 消息提示

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UserCollectionHeaderView *headerView;
@property (strong, nonatomic) UserCollectionViewCell   *cell;

@property (strong, nonatomic) NSArray *arrControllers;   // collection数据 跳转界面的数组

@property (strong, nonatomic) NSString *cacheMessageKey; // 消息缓存
@property (strong, nonatomic) NSString *cacheEndTimeKey; // 最后一条消息时间的缓存

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cacheMessageKey = [NSString stringWithFormat:@"%@_%ld", CacheKey_Messages, [UserRequest sharedInstance].user.userId];
    _cacheEndTimeKey = [NSString stringWithFormat:@"%@_%ld", CacheKey_MessageTime, [UserRequest sharedInstance].user.userId];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self registerNotification];
    [self registerCollection];
    [self configNavigationBar];
    [_collectionView reloadData];

    // 首次启动加载界面引导图
    if (![[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_NotFirstTimeMe]) {
        [self loadGuideFigure];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 检查用户是否登录，涉及到金钱，防止数据出错，每次加载到用户中心界面都刷新用户的数据，从后台拉取用户的虚拟币及积分
    if ([[UserRequest sharedInstance] online]) {
        [self getuserInfo];
        [self getNewMessage];
    }
    else {
        [[UserRequest sharedInstance] clearCache];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)updateSystemLanguage
{
    [_collectionView reloadData];
}

#pragma mark - 加载首次引导界面
- (void)loadGuideFigure
{
    GuideFigureImageView *imageV = [[GuideFigureImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    imageV.itemIndex = 2;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:imageV];
}

#pragma mark - 配置界面
- (void)configNavigationBar
{
    _imgNavigationBar = [UIImageView new];
    _imgNavigationBar.image = [UIImage imageNamed:@"icon_home_nav_bg"];
    [self.view addSubview:_imgNavigationBar];
    
    _imgMessage = [UIImageView new];
    _imgMessage.image = [UIImage imageNamed:@"icon_user_message_white"];
    _imgMessage.contentMode = UIViewContentModeCenter;
    _imgMessage.userInteractionEnabled = YES;
    [self.view addSubview:_imgMessage];
    
    _imgSet = [UIImageView new];
    _imgSet.image = [UIImage imageNamed:@"icon_user_set_white"];
    _imgSet.contentMode = UIViewContentModeCenter;
    _imgSet.userInteractionEnabled = YES;
    [self.view addSubview:_imgSet];
    
    _lblTitle = [UILabel new];
    _lblTitle.textColor = [UIColor whiteColor];
    _lblTitle.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblTitle.text = LOCALIZATION(@"我");
    [self.view addSubview:_lblTitle];
    
    _alertNewMessage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _alertNewMessage.backgroundColor = [UIColor redColor];
    _alertNewMessage.layer.cornerRadius = _alertNewMessage.width/2;
    [self.view addSubview:_alertNewMessage];
    
    [_imgNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo([IPhoneVersion deviceVersion] == iphoneX ? cHeaderHeight_88 : cHeaderHeight_64);
    }];
    
    [_imgMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgNavigationBar.mas_left);
        make.bottom.mas_equalTo(_imgNavigationBar.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(cHeaderHeight_44, cHeaderHeight_44));
    }];
    
    [_imgSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_imgNavigationBar.mas_right);
        make.bottom.mas_equalTo(_imgNavigationBar.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(cHeaderHeight_44, cHeaderHeight_44));
    }];
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_imgNavigationBar.mas_centerX);
        make.centerY.mas_equalTo(_imgMessage.mas_centerY);
    }];
    
    [_alertNewMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgMessage.mas_centerX).offset(10);
        make.bottom.mas_equalTo(_imgMessage.mas_centerY).offset(-5);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    UITapGestureRecognizer *tap_message = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessagesView)];
    [_imgMessage addGestureRecognizer:tap_message];
    
    UITapGestureRecognizer *tap_set = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setting)];
    [_imgSet addGestureRecognizer:tap_set];
}

- (void)registerCollection
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UserCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UserCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UserCollectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UserCollectionHeaderView class])];
}

- (void)createNavLeftBackItem
{

}

#pragma mark - 添加通知
- (void)registerNotification
{
    // 登录
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationUserLogin usingBlock:^(NSNotification *note) {
        [weakself.collectionView reloadData];
    }];
    // 退出登录
    [self fk_observeNotifcation:kNotificationUserLogout usingBlock:^(NSNotification *note) {
        [weakself.collectionView reloadData];
    }];
    [self fk_observeNotifcation:kNotificationNoUnReadMessage usingBlock:^(NSNotification *note) {
        weakself.alertNewMessage.hidden = YES;
    }];
}

#pragma mark - 获取用户信息
- (void)getuserInfo
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getUserInfoWithCompletion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
        else {
            // 登录后数据userid改变, 更新消息相关缓存位置
            _cacheMessageKey = [NSString stringWithFormat:@"%@_%ld", CacheKey_Messages, [UserRequest sharedInstance].user.userId];
            _cacheEndTimeKey = [NSString stringWithFormat:@"%@_%ld", CacheKey_MessageTime, [UserRequest sharedInstance].user.userId];
            [weakself.collectionView reloadData];
        }
    }];
}

#pragma mark - 消息相关

/** 没有最新消息 */
- (BOOL)noNewMessages
{
    BOOL noNews = YES;
    NSArray *arrMessage = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:_cacheMessageKey];
    // 不确定message的数量, 但是防止数量较大, 所以循环结束后销毁对象. 如果数量非常大, 那么在for循环里, 添加自动释放池
    for (MessageModel *message in arrMessage) {
        if (message.type == ENUM_MessageReadTypeUnRead) {
            noNews = NO;
            break;
        }
    }
    return noNews;
}

/** 获取新的消息 */
- (void)getNewMessage
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:now];
    NSString *lastTime = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:_cacheEndTimeKey];
    WeakSelf(self)
    [[FriendRequest sharedInstance] getMessageAndShareBookWithStartTime:lastTime endTime:dateString completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *arrNewMessage = [MessageModel mj_objectArrayWithKeyValuesArray:object];
            if (arrNewMessage.count > 0) {
                // 最新的消息
                MessageModel *lastMessage = [arrNewMessage firstObject];
                // 将最新一条消息的创建时间缓存为截止时间
                [[CacheDataSource sharedInstance] setCache:lastMessage.emailCreatedTime withCacheKey:_cacheEndTimeKey];
                NSMutableArray *arrCache = [NSMutableArray array];
                NSArray *arrOldCache = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:_cacheMessageKey];
                [arrCache addObjectsFromArray:arrOldCache];
                [arrCache addObjectsFromArray:arrNewMessage];
                [[CacheDataSource sharedInstance] setCache:arrCache withCacheKey:_cacheMessageKey];
            }
            _alertNewMessage.hidden = [self noNewMessages];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrControllers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionViewCell" forIndexPath:indexPath];
    _cell.index = indexPath.row;
    _cell.data = _arrControllers[indexPath.row];
    return _cell;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    self.headerView = (UserCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UserCollectionHeaderView class]) forIndexPath:indexPath];
    _headerView.delegate = self;
    _headerView.data = [UserRequest sharedInstance].user;
    return _headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果有用户信息（已登录） 则直接跳转界面
    if ([[UserRequest sharedInstance] online]) {
        if (0 == indexPath.row) {
            UserOrderVC *order = [UserOrderVC new];
            order.isLeaseOrder = NO;
            [self.navigationController pushViewController:order animated:YES];
        }
        else if (4 == indexPath.row && ([UserRequest sharedInstance].user.userType == ENUM_UserTypeTeacher || [UserRequest sharedInstance].user.userType == ENUM_UserTypeOrganization)) {
            [self pushToViewControllerWithStoryBoard:@"UserClass" withStoryBoardId:NSStringFromClass([UserClassVC class])];
        }
        else {
            [self pushToViewControllerWithIndex:indexPath.row];
        }
    }
    else {
        NSDictionary *dic = _arrControllers[indexPath.row];
        // 未登录状态下，除了帮助界面直接跳转，其他界面要求先登录
        if ([dic[@"class"] isEqualToString:NSStringFromClass([UserHelpVC class])])
            [self pushToViewControllerWithIndex:indexPath.row];
        else
            [self toLoginViewControll];
    }
}

#pragma mark - UserCollectionHeaderViewDelegate

/** 更换头像 */
- (void)tapAvatar
{
    if ([[UserRequest sharedInstance] online])
        [self pushVCWithStoryBoardId:NSStringFromClass([UserInfoVC class])];
    else
        [self toLoginViewControll];
}
/** 登录或修改个人信息 */
- (void)tapLoginOrUserInfo
{
    if ([[UserRequest sharedInstance] online])
        [self pushVCWithStoryBoardId:NSStringFromClass([UserInfoVC class])];
    else
        [self toLoginViewControll];
}
/** 积分 */
- (void)tapIntegral
{
    if ([[UserRequest sharedInstance] online])
        [self pushVCWithStoryBoardId:NSStringFromClass([UserIntegralVC class])];
    else
        [self toLoginViewControll];
}
/** 虚拟币 */
- (void)tapVirtualCurrency
{
    if ([[UserRequest sharedInstance] online])
        [self pushVCWithStoryBoardId:NSStringFromClass([UserVirtualCurrencyVC class])];
    else
        [self toLoginViewControll];
}
/** 晒一晒 */
- (void)shareMyReadingInfomation
{
    // 检查是否登录，登录后才可以分享，未登录要求登录
    if ([[UserRequest sharedInstance] online]) {
        if ([UserRequest sharedInstance].user.readTime > 0 || [UserRequest sharedInstance].user.readThrough > 0 || [UserRequest sharedInstance].user.wordCount > 0) {
            [self showWaitTips];
            WeakSelf(self)
            [[UserRequest sharedInstance] shareReadHistoryWithCompletion:^(id object, ErrorModel *error) {
                StrongSelf(self)
                [self dismissTips];
                if (error)
                    [self presentFailureTips:error.message];
                else
                    [self presentSuccessTips:LOCALIZATION(@"分享成功")];
            }];
        }
        else
            [self presentFailureTips:LOCALIZATION(@"没有数据可以分享, 请阅读后再来")];
    }
    else
        [self toLoginViewControll];
}

#pragma mark - 界面跳转
/** 设置 */
- (void)setting
{
    [self pushVCWithStoryBoardId:NSStringFromClass([UserSetVC class])];
}

/** 系统消息 */
- (void)toMessagesView
{
    if ([[UserRequest sharedInstance] online])
        [self pushToViewControllerWithClassName:NSStringFromClass([UserMessageVC class])];
    else
        [self toLoginViewControll];
}

/** 跳转登录界面 */
- (void)toLoginViewControll
{
    [self pushToViewControllerWithClassName:NSStringFromClass([LoginVC class])];
}

/**
 界面跳转

 @param index arrViewControllers 中的位置
 */
- (void)pushToViewControllerWithIndex:(NSInteger)index
{
    NSDictionary *dic = [_arrControllers objectAtIndex:index];
    NSString *className = [dic objectForKey:@"class"];
    [self pushToViewControllerWithStoryBoard:@"User" withStoryBoardId:className];
}

/**
 跳转到在 User storyBoard 中的界面

 @param VCId 控制器的StoryBoardId
 */
- (void)pushVCWithStoryBoardId:(NSString *)VCId
{
    [self pushToViewControllerWithStoryBoard:@"User" withStoryBoardId:VCId];
}

#pragma mark - 属性

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        
        CGFloat space = 30; // 左右边距
        CGFloat headerHeight = [IPhoneVersion deviceVersion] == iphoneX ? 500 : 430;
        _layout.sectionInset = isPad ? UIEdgeInsetsMake(0, space, 0, space) : UIEdgeInsetsMake(kCellPlace, kCellPlace, kCellPlace, kCellPlace);
        _layout.headerReferenceSize = isPad ? CGSizeMake(Screen_Width, 500 + cHeaderHeight_64) : CGSizeMake(Screen_Width, headerHeight);
        
        CGFloat itemWidth = isPad ? (Screen_Width - space * 2)/4 : (Screen_Width - kCellPlace * 2) / 4;
        CGFloat itemHeight = itemWidth;
        
        itemHeight = [IPhoneVersion deviceSize] <= iPhone4inch ? itemHeight + space : itemHeight;
        itemHeight = isPad ? itemHeight - space : itemHeight;
        
        _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CGFloat Y = [IPhoneVersion deviceVersion] == iphoneX ? -20 - cHeaderHeight_88 + cHeaderHeight_64 : -20;
        CGFloat H = [IPhoneVersion deviceVersion] == iphoneX ? Screen_Height + 34 - cHeaderHeight_88 : Screen_Height + 34 - cHeaderHeight_64;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Y, Screen_Width, H) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

/** 个人中心 collectionCell 的数据（控制器数组） */
- (NSArray *)arrControllers
{
    _arrControllers = @[@{@"class": NSStringFromClass([UserOrderVC class]),         @"title": LOCALIZATION(@"我的订阅"), @"image": @"icon_user_order"},
                        @{@"class": NSStringFromClass([UserFavouriteVC class]),     @"title": LOCALIZATION(@"我的收藏"), @"image": @"icon_user_favourite"},
                        @{@"class": NSStringFromClass([UserTicketManager class]),   @"title": LOCALIZATION(@"会员中心"), @"image": @"icon_user_wallet"},
                        @{@"class": NSStringFromClass([UserFriendManagerVC class]), @"title": LOCALIZATION(@"我的好友"), @"image": @"icon_user_friend"},
                        @{@"class": NSStringFromClass([UserClassVC class]),         @"title": LOCALIZATION(@"我的班级"), @"image": @"icon_user_class"},
                        @{@"class": NSStringFromClass([UserTaskVC class]),          @"title": LOCALIZATION(@"我的任务"), @"image": @"icon_user_task"},
                        @{@"class": NSStringFromClass([USecurityCenterVC class]),   @"title": LOCALIZATION(@"安全中心"), @"image": @"icon_user_safe"},
                        @{@"class": NSStringFromClass([UserHelpVC class]),          @"title": LOCALIZATION(@"使用帮助"), @"image": @"icon_user_help"},
                        ];
    if ([UserRequest sharedInstance].user.userType != ENUM_UserTypeTeacher && [UserRequest sharedInstance].user.userType != ENUM_UserTypeOrganization) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_arrControllers];
        [array removeObjectAtIndex:4]; // 普通用户没有我的班级
        _arrControllers = [NSArray arrayWithArray:array];
    }
    
    return _arrControllers;
}

@end
