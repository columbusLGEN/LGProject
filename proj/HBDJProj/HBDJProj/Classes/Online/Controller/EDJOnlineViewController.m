//
//  EDJOnlineViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJOnlineViewController.h"
#import "EDJHomeNav.h"
#import "EDJOnlineController.h"

static CGFloat headLineHeight = 233;

@interface EDJOnlineViewController ()<UICollectionViewDelegate>
@property (strong,nonatomic) EDJOnlineController *onlineController;
@property (strong,nonatomic) UIImageView *headLine;

@end

@implementation EDJOnlineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.onlineController.collectionView];
    self.onlineController.collectionView.delegate = self;
    
    EDJHomeNav *nav = [[EDJHomeNav alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
//    nav.delegate
    [self.view addSubview:nav];
    [self.onlineController.collectionView addSubview:self.headLine];
    
}
- (UIImageView *)headLine{
    if (_headLine == nil) {
        _headLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, - [EDJOnlineController headerHeight] - 9, kScreenWidth, headLineHeight)];
        _headLine.clipsToBounds = YES;
        _headLine.contentMode = UIViewContentModeScaleAspectFill;
        _headLine.image = [UIImage imageNamed:@"party_history"];
    }
    return _headLine;
}

- (EDJOnlineController *)onlineController{
    if (_onlineController == nil) {
        _onlineController = [EDJOnlineController new];
    }
    return _onlineController;
}

@end
