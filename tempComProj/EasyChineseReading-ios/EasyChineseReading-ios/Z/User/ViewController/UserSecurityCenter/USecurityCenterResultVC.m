//
//  USCResult.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "USecurityCenterResultVC.h"
#import "USecurityCenterVC.h"
#import "LoginVC.h"

@interface USecurityCenterResultVC ()

@end

@implementation USecurityCenterResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configResultView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    WeakSelf(self)
    // 修改成功2s以后退出登录状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        StrongSelf(self)
        [[UserRequest sharedInstance] logoutWithCompletion:^(id object, ErrorModel *error) {
            if (error)
                [self presentFailureTips:error.message];
        }];
        // 清楚缓存、发布退出通知
        [[UserRequest sharedInstance] signout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"设置成功");
}

- (void)createNavLeftBackItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[back];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;// 解决自定义导航栏按钮导致系统的左滑pop 失效
}

- (void)configResultView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_success"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.height/2;
    [self.view addSubview:imageView];
    
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.text = LOCALIZATION(@"设置成功");
    lblDesc.textColor = [UIColor cm_grayColor__807F7F_1];
    [self.view addSubview:lblDesc];
    
    UILabel *lblReturn = [[UILabel alloc] init];
    lblReturn.textColor = [UIColor cm_grayColor__807F7F_1];
    lblReturn.userInteractionEnabled = YES;
    NSString *textStr = _securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodForget || _securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodPassword ? LOCALIZATION(@"返回登录>") : LOCALIZATION(@"返回安全中心>");
    
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    // 赋值
    lblReturn.attributedText = attribtStr;
    [self.view addSubview:lblReturn];
    WeakSelf(self)
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(imageView.mas_centerX);
    }];
    
    [lblReturn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblDesc.mas_bottom).offset(25);
        make.centerX.equalTo(lblDesc.mas_centerX);
    }];
    
    UITapGestureRecognizer *tapReturn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baseViewControllerDismiss)];
    [lblReturn addGestureRecognizer:tapReturn];
}


/** 返回 */
- (void)baseViewControllerDismiss
{
    // 根据修改的来源决定修改成功后返回到哪一个界面
    for (UIViewController *temp in self.navigationController.viewControllers) {
        // 修改登录密码
        if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodPassword) {
            WeakSelf(self)
            [[UserRequest sharedInstance] logoutWithCompletion:^(id object, ErrorModel *error) {
                if (error)
                    [weakself presentFailureTips:error.message];
            }];
            // 清楚缓存、发布退出通知
            [[UserRequest sharedInstance] signout];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        // 从用户中心跳转来
        if ([temp isKindOfClass:[USecurityCenterVC class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
        // 用登录界面跳转来
        else if ([temp isKindOfClass:[LoginVC class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

@end
