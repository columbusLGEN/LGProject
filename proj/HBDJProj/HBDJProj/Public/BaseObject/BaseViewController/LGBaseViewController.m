//
//  LIGBaseViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@interface LGBaseViewController ()

@end

@implementation LGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavLeftBackItem];
    [self otherConfig];
}

- (void)otherConfig{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.startReadDate = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setNavLeftBackItem{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);// 设置内边距，以调整按钮位置
    [backButton setImage:[UIImage imageNamed:@"icon_arrow_left_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItems = @[back];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;// 解决自定义导航栏按钮导致系统的左滑pop 失效
}

- (void)lg_dismissViewController{
    switch (_pushWay) {
        case LGBaseViewControllerPushWayPush:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case LGBaseViewControllerPushWayModal:
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}


/// 部分需要调用用户增加积分接口的方法
- (void)IntegralGrade_addWithIntegralid:(DJUserAddScoreType)integralid{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval readSeconds = [currentDate timeIntervalSinceDate:self.startReadDate];
    NSTimeInterval readMins = readSeconds / 60;
    NSLog(@"查看时间——分钟: %f",readMins);
    
    [DJUserNetworkManager.sharedInstance frontIntegralGrade_addWithIntegralid:integralid completenum:readMins success:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
}


@end
