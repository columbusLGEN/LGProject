//
//  UFriendVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserFriendManagerVC.h"

#import "UFriendDynamicViewController.h"
#import "UFriendListViewController.h"

@interface UserFriendManagerVC ()

@property (strong, nonatomic) UFriendDynamicViewController *dynamicVC; // 动态
@property (strong, nonatomic) UFriendListViewController    *friendsVC; // 好友

@property (strong, nonatomic) ZSegment *segment;

@end

@implementation UserFriendManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configFriendManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 配置我的好友

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"我的好友");
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configFriendManager
{
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"好友动态") rightTitle:LOCALIZATION(@"我的好友")];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        [weakself.view bringSubviewToFront:weakself.dynamicVC.view];
    };
    _segment.selectedRight = ^{
        [weakself.view bringSubviewToFront:weakself.friendsVC.view];
    };
    
    [self configFriendsView];
    [self configDynamicView];
}

- (void)configFriendsView {
    _friendsVC = [UFriendListViewController new];
    _friendsVC.view.frame = CGRectMake(0, 44, Screen_Width, self.view.height - 44);
    
    [self addChildViewController:_friendsVC];
    [self.view addSubview:_friendsVC.view];
}

- (void)configDynamicView {
    _dynamicVC = [UFriendDynamicViewController new];
    _dynamicVC.view.frame = CGRectMake(0, 44, Screen_Width, self.view.height - 44);
    
    [self addChildViewController:_dynamicVC];
    [self.view addSubview:_dynamicVC.view];
}

@end
