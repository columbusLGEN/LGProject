//
//  USecurityCenter.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "USecurityCenterVC.h"
#import "USecurityCenterVerifyVC.h"

@interface USecurityCenterVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblDescLoginPassword;     // 描述 登录密码
@property (weak, nonatomic) IBOutlet UILabel *lblDescEmail;             // 描述 绑定邮箱
@property (weak, nonatomic) IBOutlet UILabel *lblDescPhone;             // 描述 绑定手机

@property (weak, nonatomic) IBOutlet UILabel *lblSubDescLoginPassword;  // 子描述 登录密码
@property (weak, nonatomic) IBOutlet UILabel *lblSubDescEmail;          // 子描述 绑定邮箱
@property (weak, nonatomic) IBOutlet UILabel *lblSubDescPhone;          // 子描述 绑定手机

@property (weak, nonatomic) IBOutlet UIImageView *imgPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow0;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow1;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow2;

@end

@implementation USecurityCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSecurityCenterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"安全中心");
    
    _lblDescLoginPassword.text = LOCALIZATION(@"登录密码");
    _lblDescEmail.text         = LOCALIZATION(@"邮箱绑定");
    _lblDescPhone.text         = LOCALIZATION(@"手机绑定");
    
    _lblSubDescLoginPassword.text = LOCALIZATION(@"建议您定期修改登录密码，以保账户安全。");
    _lblSubDescEmail.text         = LOCALIZATION(@"邮箱验证后，修改密码，确保账户安全。");
    _lblSubDescPhone.text         = LOCALIZATION(@"验证手机后，修改密码，确保账户安全。");
}

- (void)configSecurityCenterView
{
    CGFloat fontSize = [IPhoneVersion deviceSize] > iPhone4inch ? 14.f : 12.f;

    _lblSubDescLoginPassword.font = [UIFont systemFontOfSize:fontSize];
    _lblSubDescEmail.font         = [UIFont systemFontOfSize:fontSize];
    _lblSubDescPhone.font         = [UIFont systemFontOfSize:fontSize];
    
    _imgPassword.image = [UIImage imageNamed:@"icon_safe_password_login"];
    _imgEmail.image = [UIImage imageNamed:@"icon_safe_email"];
    _imgPhone.image = [UIImage imageNamed:@"icon_safe_phone"];
    _imgRightArrow0.image = _imgRightArrow1.image = _imgRightArrow2.image = [UIImage imageNamed:@"icon_arrow_right"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    USecurityCenterVerifyVC *verifyVC = [[USecurityCenterVerifyVC alloc] init];
    verifyVC.securityCenterUpdateType = indexPath.row;
    verifyVC.verifyLoginUser          = YES;
    [self.navigationController pushViewController:verifyVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 分割线左右间距为0
    [cell setCellSeparatorInset:UIEdgeInsetsZero];
}

@end
