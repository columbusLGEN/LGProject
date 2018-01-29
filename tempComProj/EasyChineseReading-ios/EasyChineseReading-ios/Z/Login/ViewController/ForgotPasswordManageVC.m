//
//  ForgotPasswordManageVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ForgotPasswordManageVC.h"

#import "ForgotPasswordVC.h"

@interface ForgotPasswordManageVC ()

@property (strong, nonatomic) ForgotPasswordVC *forgotPasswordPhone;
@property (strong, nonatomic) ForgotPasswordVC *forgotPasswordEmail;

@property (strong, nonatomic) ZSegment *segment;

@end

@implementation ForgotPasswordManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"忘记密码");
    self.view.backgroundColor = [UIColor whiteColor];
    
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"手机号") rightTitle:LOCALIZATION(@"邮箱")];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        [weakself.view bringSubviewToFront:weakself.forgotPasswordPhone.view];
    };
    _segment.selectedRight = ^{
        [weakself.view bringSubviewToFront:weakself.forgotPasswordEmail.view];
    };
    
    [self configForgotPasswordEmail];
    [self configForgotPasswordPhone];
}

#pragma mark -
/** 跳转手机修改密码 */
- (void)configForgotPasswordPhone {
    _forgotPasswordPhone = [ForgotPasswordVC new];
    _forgotPasswordPhone.view.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44);
    _forgotPasswordPhone.accountType = ENUM_AccountTypePhone;
    
    [self addChildViewController:_forgotPasswordPhone];
    [self.view addSubview:_forgotPasswordPhone.view];
}
/** 跳转邮箱修改密码 */
- (void)configForgotPasswordEmail {
    _forgotPasswordEmail = [ForgotPasswordVC new];
    _forgotPasswordEmail.view.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44);
    _forgotPasswordEmail.accountType = ENUM_AccountTypeEmail;

    [self addChildViewController:_forgotPasswordEmail];
    [self.view addSubview:_forgotPasswordEmail.view];
}

@end
