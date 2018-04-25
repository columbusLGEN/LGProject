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
#import <Online/addMoreTool/controller/OLAddMoreToolViewController.h>

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
    
    [self.onlineController getDataWithPlistName:@"OLHomeItems"];
    [self.view addSubview:self.onlineController.collectionView];
    self.onlineController.collectionView.delegate = self;
    
    EDJHomeNav *nav = [[EDJHomeNav alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    [self.view addSubview:nav];
    [self.onlineController.collectionView addSubview:self.headLine];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.onlineController.onlineModels.count - 1) {
        /// 跳转至 添加更多工具
        OLAddMoreToolViewController *vc = [OLAddMoreToolViewController new];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;/// 保留当前的上下文.即半透明看到父控制器效果
        vc.pushWay = LGBaseViewControllerPushWayModal;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
    }
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
