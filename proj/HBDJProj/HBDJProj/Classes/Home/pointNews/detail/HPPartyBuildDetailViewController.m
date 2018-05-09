//
//  HPPartyBuildDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPartyBuildDetailViewController.h"
#import "PBDBottomView.h"

@interface HPPartyBuildDetailViewController ()<
PBDBottomViewDelegate>

@end

@implementation HPPartyBuildDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    PBDBottomView *pbdBottom = [PBDBottomView pbdBottom];
    pbdBottom.delegate = self;
    CGFloat bottomHeight = 60;
    BOOL isiPhoneX = ([LGDevice sharedInstance].currentDeviceType == LGDeviecType_iPhoneX);
    if (isiPhoneX) {
        bottomHeight = 90;
    }
    pbdBottom.frame = CGRectMake(0, kScreenHeight - bottomHeight, kScreenWidth, bottomHeight);
    [self.view addSubview:pbdBottom];
}

#pragma mark - PBDBottomViewDelegate
- (void)pbdBottomClick:(PBDBottomView *)bottomView action:(PBDBottomAction)action {
    switch (action) {
        case PBDBottomActionLike:
            NSLog(@"点赞 -- ");
            break;
        case PBDBottomActionCollect:
            NSLog(@"收藏 -- ");
            break;
        case PBDBottomActionShare:
            NSLog(@"分享 -- ");
            break;
            
    }
}


@end
