//
//  USCUpdateVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "USecurityCenterUpdateVC.h"

#import "USCPasswordTableViewCell.h"

#import "USecurityCenterResultVC.h"

@interface USecurityCenterUpdateVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *btnNext;
/** 密码 */
@property (strong, nonatomic) NSString *password;
/** 重复密码 */
@property (strong, nonatomic) NSString *rePassword;
/** 修改密码的类型 */
@property (assign, nonatomic) ENUM_UpdatePasswordType updateType;

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation USecurityCenterUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = _securityCenterUpdateType == ENUM_UpdatePasswordTypePay ? LOCALIZATION(@"支付密码") : LOCALIZATION(@"登录密码");
    [_tableView reloadData];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, self.view.height - 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = cHeaderHeight_54;
    _tableView.sectionFooterHeight = 200.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USCPasswordTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USCPasswordTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    USCPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USCPasswordTableViewCell class])];
    if (0 == indexPath.row)
        cell.txtfPassword.placeholder = [NSString stringWithFormat:@"%@", LOCALIZATION(@"请输入新密码")];
    else
        cell.txtfPassword.placeholder = LOCALIZATION(@"请确认新密码");
    
    [self configTextWithCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self footerView];
}

#pragma mark - action

/** 获取输入的密码 */
- (void)configTextWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    USCPasswordTableViewCell *pCell = (USCPasswordTableViewCell *)cell;
    if (0 == indexPath.row)
        [pCell.txtfPassword addTarget:self action:@selector(textFieldWithPassword:) forControlEvents:UIControlEventEditingChanged];
    else
        [pCell.txtfPassword addTarget:self action:@selector(textFieldWithRePassword:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldWithPassword:(UITextField *)textField
{
    _password = textField.text;
}

- (void)textFieldWithRePassword:(UITextField *)textField
{
    _rePassword = textField.text;
}

- (void)click_btnNext
{
    [self proveValidityPassword];
}

/** 验证密码的有效性 */
- (void)proveValidityPassword
{
    if ([_password notPassword]) { // 密码格式错误
        [self presentFailureTips:LOCALIZATION(@"密码为8-16个字符，由英文、数字组成")];
    }
    else if (![_password isEqualToString:_rePassword]) { // 密码不同
        [self presentFailureTips:LOCALIZATION(@"两次输入的密码不一样，请确认后重新输入")];
    }
    else {
        if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodForget)
            [self forgetPassword];
        else
            [self updatePassword];
    }
}

/** 更新密码 */
- (void)updatePassword
{
    if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodPassword)
        _updateType = ENUM_UpdatePasswordTypeLogin;
    else if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodPay)
        _updateType = ENUM_UpdatePasswordTypePay;

    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] updatePasswordWithType:[NSString stringWithFormat:@"%ld", _updateType]
                                                  userId:_userId
                                                password:_password
                                              completion:^(id object, ErrorModel *error) {
                                                  StrongSelf(self)
                                                  [self dismissTips];
                                                  if (error) {
                                                      [self presentFailureTips:error.message];
                                                  }
                                                  else {
                                                      USecurityCenterResultVC *result = [USecurityCenterResultVC new];
                                                      result.securityCenterUpdateType = _securityCenterUpdateType;
                                                      [self.navigationController pushViewController:result animated:YES];
                                                  }
                                              }];
}

/** 忘记密码 */
- (void)forgetPassword
{
    [self showWaitTips];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    NSNumber *number = [nf numberFromString:_areacode];
    WeakSelf(self)
    [[UserRequest sharedInstance] forgetPasswordWithAccount:_account
                                                accountType:_accountType
                                                   areacode:[NSString stringWithFormat:@"%ld", number.integerValue]
                                                   password:_password
                                                 completion:^(id object, ErrorModel *error) {
                                                     StrongSelf(self)
                                                     [self dismissTips];
                                                     if (error) {
                                                         [self presentFailureTips:error.message];
                                                     }
                                                     else {
                                                         USecurityCenterResultVC *result = [USecurityCenterResultVC new];
                                                         result.securityCenterUpdateType = ENUM_ZUserSecurityCenterUpdateMethodForget;
                                                         [self.navigationController pushViewController:result animated:YES];
                                                     }
                                                 }];
}

#pragma mark - 属性
/** tableViewFooterView */
- (UIView *)footerView
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_Width - 86 * 2, cButtonHeight_40)];
    _btnNext.backgroundColor = [UIColor cm_mainColor];
    _btnNext.layer.masksToBounds = YES;
    _btnNext.layer.cornerRadius = _btnNext.height/2;
    [_btnNext setTitle:LOCALIZATION(@"下一步") forState:UIControlStateNormal];
    [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnNext addTarget:self action:@selector(click_btnNext) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_btnNext];
    [_btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 86 * 2, cButtonHeight_40));
        make.left.mas_equalTo(footerView.mas_left).offset(86);
    }];
    
    return footerView;
}

@end
