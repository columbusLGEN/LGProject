//
//  EDJOnlineViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJOnlineViewController.h"

#import "LGNavigationSearchBar.h"

#import "EDJOnlineController.h"
#import "OLAddMoreToolViewController.h"
#import "OLMindReportViewController.h"

#import "OLHomeModel.h"
#import "OLSkipObject.h"
#import "DJOnlineNetorkManager.h"

static CGFloat headLineHeight = 233;

@interface EDJOnlineViewController ()<UICollectionViewDelegate>
@property (strong,nonatomic) EDJOnlineController *onlineController;
@property (strong,nonatomic) UIImageView *headLine;

@end

@implementation EDJOnlineViewController

- (instancetype)init{
    if (self = [super init]) {
        /// 获取数据
        [[DJOnlineNetorkManager sharedInstance] onlineHomeConfigSuccess:^(id responseObj) {
           NSLog(@"onlinehomeconfig_success: %@",responseObj);
            
        } failure:^(id failureObj) {
           NSLog(@"onlinehomeconfig_failure: %@",failureObj);
            
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.onlineController getDataWithPlistName:@"OLHomeItems"];
    [self.view addSubview:self.onlineController.collectionView];
    self.onlineController.collectionView.delegate = self;
    
    LGNavigationSearchBar *nav = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    [self.view addSubview:nav];
    [self.onlineController.collectionView addSubview:self.headLine];
    
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OLHomeModel *model = self.onlineController.onlineModels[indexPath.row];
    if (indexPath.item == self.onlineController.onlineModels.count - 1) {
        /// 跳转至 添加更多工具
        OLAddMoreToolViewController *vc = [OLAddMoreToolViewController new];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        vc.pushWay = LGBaseViewControllerPushWayModal;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
//        OLMindReportViewController *vc = [OLMindReportViewController new];
//        vc.title = model.title;
//        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController pushViewController:[OLSkipObject viewControllerWithOLHomeModelType:model] animated:YES];
        
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
