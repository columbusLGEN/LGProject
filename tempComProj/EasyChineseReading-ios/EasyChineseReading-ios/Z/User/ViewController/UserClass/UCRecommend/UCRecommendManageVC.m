//
//  UCRecommendManageVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCRecommendManageVC.h"

#import "ZSlideSwitch.h"

#import "UCRecommendListVC.h"
#import "UCRecommendBooksVC.h"
#import "ECRClassSortModel.h"

@interface UCRecommendManageVC () <ZSlideSwitchDelegate>

@property (strong, nonatomic) UCRecommendListVC *recommendVC;   // 推荐
@property (strong, nonatomic) UCRecommendListVC *impowerVC;     // 授权
@property (assign, nonatomic) ENUM_RecommendType recommendType; // 推荐类型
@property (strong, nonatomic) ZSegment *segment;

@end

@implementation UCRecommendManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"推荐阅读");
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"推荐") style:UIBarButtonItemStylePlain target:self action:@selector(recommendBooks)];
    
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"推荐阅读") rightTitle:LOCALIZATION(@"授权阅读")];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        StrongSelf(self)
         self.navigationItem.rightBarButtonItem.title = LOCALIZATION(@"推荐");
        [self selectedRecommendView];
    };
    _segment.selectedRight = ^{
        StrongSelf(self)
        self.navigationItem.rightBarButtonItem.title = LOCALIZATION(@"授权");
        [self selectedImpowerView];
    };
    
    [self configImpowerView];
    [self configRecommendView];
    
    _recommendType = ENUM_RecommendTypeRecommend;
}

#pragma mark - action

/** 去推荐/授权 */
- (void)recommendBooks
{
    UCRecommendBooksVC *recommendBooks = [[UCRecommendBooksVC alloc] init];
    recommendBooks.recommendType = _recommendType;
    recommendBooks.openType = _recommendType == ENUM_RecommendTypeRecommend ? ECRMoreBookOpenTypeDefault : ECRMoreBookOpenTypeAccess;
    recommendBooks.classModel    = [ECRClassSortModel defaultModel];

    [self.navigationController pushViewController:recommendBooks animated:YES];
}

/** 推荐 */
- (void)selectedRecommendView
{
    _recommendType = ENUM_RecommendTypeRecommend;
    [self.view bringSubviewToFront:_recommendVC.view];
}

/** 授权 */
- (void)selectedImpowerView
{
    _recommendType = ENUM_RecommendTypeImpower;
    [self.view bringSubviewToFront:_impowerVC.view];
}

#pragma mark - 配置推荐授权列表

/** 推荐 */
- (void)configRecommendView {
    _recommendVC = [UCRecommendListVC new];
    _recommendVC.recommendType = ENUM_RecommendTypeRecommend;
    _recommendVC.view.frame = CGRectMake(0, 44, Screen_Width, self.view.height - 44);
    
    [self addChildViewController:_recommendVC];
    [self.view addSubview:_recommendVC.view];
}

/** 授权 */
- (void)configImpowerView {
    _impowerVC = [UCRecommendListVC new];
    _impowerVC.recommendType = ENUM_RecommendTypeImpower;
    _impowerVC.view.frame = CGRectMake(0, 44, Screen_Width, self.view.height - 44);
    
    [self addChildViewController:_impowerVC];
    [self.view addSubview:_impowerVC.view];
}

@end
