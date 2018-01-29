//
//  USCVerifyVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "USecurityCenterVerifyVC.h"

#import "USPhoneTableViewCell.h"
#import "USEmailTableViewCell.h"
#import "USCVerifyTableViewCell.h"

#import "USecurityCenterUpdateVC.h"
#import "USecurityCenterResultVC.h"
#import "UserInfoAddressVC.h"

@interface USecurityCenterVerifyVC () <UITableViewDelegate, UITableViewDataSource, USCVerifyTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
/* 是否需要选择验证方式（手机或邮箱） */
@property (assign, nonatomic) BOOL needSelectdVerityType;
/* 验证的方式 1-手机，2-邮箱 */
@property (assign, nonatomic) ENUM_AccountType accountType;
/* 验证码 cell 的 indexPath */
@property (strong, nonatomic) NSIndexPath *verifyIndexPath;
/* 下一步 */
@property (strong, nonatomic) UIButton *btnNext;
/* 计时器 */
@property (strong, nonatomic) NSTimer *timer;
/* 倒计时时间 */
@property (assign, nonatomic) NSInteger timeDown;
/** 验证码 */
@property (strong, nonatomic) NSString *verifyCode;
/** 邮箱 */
@property (strong, nonatomic) NSString *email;
/** 手机 */
@property (strong, nonatomic) NSString *phone;
/** 国家码 */
@property (strong, nonatomic) NSString *areacode;
/** 顶部选择条 */
@property (strong, nonatomic) ZSegment *segment;

@end

@implementation USecurityCenterVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configVerifyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    NSString *title = @"";
    switch (_securityCenterUpdateType) {
        case ENUM_ZUserSecurityCenterUpdateMethodPassword: title = LOCALIZATION(@"修改密码"); break;
        case ENUM_ZUserSecurityCenterUpdateMethodEmail:    title = LOCALIZATION(@"邮箱绑定"); break;
        case ENUM_ZUserSecurityCenterUpdateMethodPhone:    title = LOCALIZATION(@"手机绑定"); break;
        case ENUM_ZUserSecurityCenterUpdateMethodPay:      title = LOCALIZATION(@"支付密码"); break;
        case ENUM_ZUserSecurityCenterUpdateMethodForget:   title = LOCALIZATION(@"忘记密码"); break;
        default: break;
    }
    self.title = title;
    [_tableView reloadData];
}

/** 配置验证界面 */
- (void)configVerifyView
{
    // 获取登录用户信息
    _user = [UserRequest sharedInstance].user;
    // 忘记密码
    if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodForget) {
        _accountType = ENUM_AccountTypePhone;
        _needSelectdVerityType = YES;
        _verifyLoginUser = NO;
    }
    // 安全中心操作
    else {
        // 验证登录用户界面
        if (_verifyLoginUser == YES) {
            // 判断是否需要选择手机或邮箱
            _needSelectdVerityType = _user.phone.length > 0 && _user.email.length > 0 ? YES : NO;
            // 如果有手机号 验证手机号 否则验证邮箱
            _accountType = _user.phone.length > 0 ? ENUM_AccountTypePhone : ENUM_AccountTypeEmail;
        }
        // 修改邮箱手机界面
        else {
            _needSelectdVerityType = NO;
            if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodPhone) {
                _accountType = ENUM_AccountTypePhone;
            }
            else if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodEmail) {
                _accountType = ENUM_AccountTypeEmail;
            }
        }
    }
    [self configHeaderView];
    [self configTableView];
}

/** 配置顶部选择条 */
- (void)configHeaderView
{
    // 如果只有手机或邮箱 不需要创建顶部选择试图
    if (_needSelectdVerityType == NO)
        return;
    
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"手机号") rightTitle:LOCALIZATION(@"邮箱")];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        weakself.accountType = ENUM_AccountTypePhone;
        [weakself.tableView reloadData];
    };
    _segment.selectedRight = ^{
        weakself.accountType = ENUM_AccountTypeEmail;
        [weakself.tableView reloadData];
    };
}

/** 配置列表 */
- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _needSelectdVerityType ? cHeaderHeight_54 + 20 : 20, Screen_Width, self.view.height - cHeaderHeight_54 - 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = cHeaderHeight_54;
    _tableView.sectionFooterHeight = 200.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USPhoneTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USPhoneTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USEmailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USEmailTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USCVerifyTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USCVerifyTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        USPhoneTableViewCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USPhoneTableViewCell class])];
        USEmailTableViewCell *emailCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USEmailTableViewCell class])];
        [phoneCell.txtfAccount  addTarget:self action:@selector(textDidChangedWithTextField:) forControlEvents:UIControlEventEditingChanged];
        [emailCell.txtfAccount  addTarget:self action:@selector(textDidChangedWithTextField:) forControlEvents:UIControlEventEditingChanged];
        // 判断是验证界面还是修改界面，如果是验证界面则不能修改手机与邮箱，如果是修改界面则可以修改手机或邮箱
        phoneCell.isUpdated = !_verifyLoginUser;
        emailCell.isUpdated = !_verifyLoginUser;
        WeakSelf(self)
        // 修改国家码回调
        phoneCell.selectedAreacode = ^{
            [weakself toSelectCountry];
        };
        // 验证已有的手机/邮箱
        if (_verifyLoginUser == YES) {
            if (_accountType == ENUM_AccountTypePhone) {
                phoneCell.txtfAreacode.text = [NSString stringWithFormat:@"+%04ld", _user.areacode];
                phoneCell.txtfAccount.text = [NSString stringWithFormat:@"%@", _user.phone];
            }
            else {
                emailCell.txtfAccount.text = _user.email;
                return emailCell;
            }
        }
        // 修改手机/邮箱界面
        else {
            if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodEmail) {
                return emailCell;
            }
            else if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodForget) {
                if (_accountType == ENUM_AccountTypeEmail) {
                    return emailCell;
                }
            }
        }
        return phoneCell;
    }
    else {
        USCVerifyTableViewCell *verifyCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USCVerifyTableViewCell class])];
        verifyCell.delegate = self;
        _verifyIndexPath = indexPath;
        [verifyCell.txtfVerity addTarget:self action:@selector(verifyWithText:) forControlEvents:UIControlEventEditingChanged];
        return verifyCell;
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self footerView];
}

#pragma mark - action

/** 获取输入的内容 */
- (void)textDidChangedWithTextField:(UITextField *)textField
{
    if (_verifyLoginUser == NO) {
        // 绑定邮箱
        if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodEmail) {
            _email = textField.text;
        }
        // 绑定手机
        else if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodPhone) {
            if (textField.tag == 100) {
                _phone = textField.text;
            }
            else {
                _areacode = textField.text;
            }
        }
        // 忘记密码
        else if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodForget) {
            if (_accountType == ENUM_AccountTypePhone) {
                if (textField.tag == 100) {
                    _phone = textField.text;
                }
                else {
                    _areacode = textField.text;
                }
                _email = @"";
            }
            else {
                _email = textField.text;
                _phone = @"";
                _areacode = @"";
            }
        }
    }
}

- (void)verifyWithText:(UITextField *)textField
{
    _verifyCode = textField.text;
    if (_verifyCode.length > 6) {
        _verifyCode = [_verifyCode substringToIndex:6];
        textField.text = _verifyCode;
    }
    if (_verifyLoginUser == YES) {
        _btnNext.enabled = _verifyCode.length > 0;
        _btnNext.backgroundColor = _verifyCode.length > 0 ? [UIColor cm_mainColor] : [UIColor cm_grayColor__F1F1F1_1];
    }
    else {
        // 可以进行下一步（下一步可点）[验证码 && ((手机&&国际码)||邮箱)]
        BOOL canNext = _verifyCode.length > 0 && ((_phone.length > 0 && _areacode.length > 0) || _email.length > 0);
        _btnNext.enabled = canNext;
        _btnNext.backgroundColor = canNext ? [UIColor cm_mainColor] : [UIColor cm_grayColor__F1F1F1_1];
    }
}

#pragma mark - 选择国家

/** 选择国家 */
- (void)toSelectCountry
{
    USPhoneTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = [UserRequest sharedInstance].language;
    WeakSelf(self)
    addressVC.selectedCountryBlock = ^(CountryModel * country){
        weakself.areacode = country.areacode;
        [cell updateAreacodeWithAreacode:country.areacode];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark - USCVerifyTableViewCellDelegate 发送验证码

/** 发送验证码 */
- (void)sendVerifyCode
{
    if (_timeDown > 0) {
        return;
    }
    // 验证手机/邮箱
    if (_verifyLoginUser) {
        [self configTimer];
        if (_accountType == ENUM_AccountTypeEmail)
            [self sendEmailCodeWithEmail:_user.email];
        else if (_accountType == ENUM_AccountTypePhone)
            [self sendPhoneCodeWithPhone:_user.phone areacode:[NSString stringWithFormat:@"%ld", _user.areacode]];
    }
    // 修改手机/邮箱
    else {
        if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodEmail) {
            if (_email.length > 0 && [_email isEmail]) {
                [self configTimer];
                [self sendEmailCodeWithEmail:_email];
            }
            else {
                [self presentFailureTips:LOCALIZATION(@"请输入正确格式的邮箱")];
            }
        }
        else if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodPhone) {
            if (_phone.length > 0 && [_phone isNumber]) {
                if (_areacode.length > 0) {
                    [self configTimer];
                    [self sendPhoneCodeWithPhone:_user.phone areacode:_areacode];
                }
                else {
                    [self presentFailureTips:LOCALIZATION(@"国家码不能为空")];
                }
            }
            else {
                [self presentFailureTips:LOCALIZATION(@"请输入正确格式的手机号")];
            }
        }
        else if (_securityCenterUpdateType == ENUM_ZUserSecurityCenterUpdateMethodForget) {
            if (_accountType == ENUM_AccountTypePhone) {
                if (_phone.length > 0 && [_phone isNumber]) {
                    if (_areacode.length > 0) {
                        [self configTimer];
                        [self sendPhoneCodeWithPhone:_user.phone areacode:_areacode];
                    }
                    else {
                        [self presentFailureTips:LOCALIZATION(@"国家码不能为空")];
                    }
                }
                else {
                    [self presentFailureTips:LOCALIZATION(@"请输入正确格式的手机号")];
                }
            }
            else {
                if (_accountType == ENUM_AccountTypeEmail) {
                    if (_email.length > 0 && [_email isEmail]) {
                        [self configTimer];
                        [self sendEmailCodeWithEmail:_email];
                    }
                    else {
                        [self presentFailureTips:LOCALIZATION(@"请输入正确格式的邮箱")];
                    }
                }
            }
        }
    }
}

/** 发送邮箱验证码 */
- (void)sendEmailCodeWithEmail:(NSString *)email
{
    WeakSelf(self)
    [[UserRequest sharedInstance] sendEmailCodeWithEmail:email completion:^(id object, ErrorModel *error) {
        if (error) {
            [weakself presentFailureTips:error.message];
        }
    }];
}

/** 发送手机验证码 */
- (void)sendPhoneCodeWithPhone:(NSString *)phone areacode:(NSString *)areacode
{
    WeakSelf(self)
    [[UserRequest sharedInstance] sendPhoneCodeWithPhone:phone areacode:areacode completion:^(id object, ErrorModel *error) {
        if (error) {
            [weakself presentFailureTips:error.message];
        }
    }];
}

#pragma mark - 下一步
/** 点击下一步 */
- (void)click_btnNext
{
    // 6位的数字验证码
    if (_verifyCode.length == 6 && [_verifyCode isNumber]) {
        if (_verifyLoginUser == YES) {
            [self showWaitTips];
            [self checkVerifyCode];
        }
        else {
            [self personVerifySingleWithAccount:(_accountType == ENUM_AccountTypePhone ? _phone : _email) accountType:[NSString stringWithFormat:@"%ld", _accountType]];
        }
    }
    else {
        [self presentFailureTips:LOCALIZATION(@"请输入正确的验证码")];
    }
}

/**
 普通用户验证账号唯一性
 
 @param accountType 账号类型（手机 邮箱）
 */
- (void)personVerifySingleWithAccount:(NSString *)account accountType:(NSString *)accountType
{
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:account userType:accountType completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {// error.code = 1 有账号
            [self dismissTips];
            [self presentFailureTips:error.message];
        }
        else {
            // 数据中没有该账号 可以使用
            [self checkVerifyCode];
        }
    }];
}

/** 验证验证码 */
- (void)checkVerifyCode
{
    WeakSelf(self)
    NSString *accout = _accountType == ENUM_AccountTypePhone ? ([_phone notEmpty] ? _phone : _user.phone) : ([_email notEmpty] ? _email : _user.email);
    [[UserRequest sharedInstance] verityCodeWithType:[NSString stringWithFormat:@"%ld", (long)_accountType] verifi:_verifyCode account:accout completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error)
            [self presentFailureTips:error.message];
        else
            [self toNextViewController];
    }];
}

/** 界面跳转 */
- (void)toNextViewController
{
    USecurityCenterUpdateVC *updateVC = [[USecurityCenterUpdateVC alloc] init];
    USecurityCenterVerifyVC *verifyVC = [[USecurityCenterVerifyVC alloc] init];
    
    verifyVC.securityCenterUpdateType = _securityCenterUpdateType;
    updateVC.securityCenterUpdateType = _securityCenterUpdateType;
    
    switch (_securityCenterUpdateType) {
        case ENUM_ZUserSecurityCenterUpdateMethodPassword:  // 修改登录密码
        case ENUM_ZUserSecurityCenterUpdateMethodPay:       // 修改支付密码
        case ENUM_ZUserSecurityCenterUpdateMethodForget:    // 忘记密码
            [self.navigationController pushViewController:updateVC animated:YES];
            break;
        case ENUM_ZUserSecurityCenterUpdateMethodEmail:     // 修改绑定邮箱
        case ENUM_ZUserSecurityCenterUpdateMethodPhone:     // 修改绑定手机
            if (_verifyLoginUser == NO) {
                [self savePhoneOrEmail];
                break;
            }
            verifyVC.verifyLoginUser = NO;
            [self.navigationController pushViewController:verifyVC animated:YES];
            break;
        default:
            break;
    }
}

/** 保存邮箱或手机 */
- (void)savePhoneOrEmail
{
    [self showWaitTips];
    NSString *type = [NSString stringWithFormat:@"%ld", _accountType];
    NSString *account = _accountType == ENUM_AccountTypePhone ? _phone : _email;
    WeakSelf(self)
    [[UserRequest sharedInstance] updateUserInfoWithType:type account:account areacode:_areacode completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            USecurityCenterResultVC *resultVC = [[USecurityCenterResultVC alloc] init];
            resultVC.securityCenterUpdateType = _securityCenterUpdateType;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
    }];
}

#pragma mark - 配置计时器
/** 配置计时器 */
- (void)configTimer
{
    _timeDown = 60; // 倒计时 60s
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES]; // 每秒更新一次倒计时
}

/** 计时器方法实现 */
- (void)timerFireMethod:(NSTimer *)timer
{
    USCVerifyTableViewCell *cell = [_tableView cellForRowAtIndexPath:_verifyIndexPath];
    if (_timeDown > 0) {
        _timeDown -= 1;
        cell.btnSendVerify.userInteractionEnabled = NO;
        [cell.btnSendVerify setTitle:[NSString stringWithFormat:@"%ld", (long)_timeDown] forState:UIControlStateNormal];
    }
    else {
        cell.btnSendVerify.userInteractionEnabled = YES;
        [cell.btnSendVerify setTitle:LOCALIZATION(@"获取验证码") forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 属性
- (UIView *)footerView
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_Width - 86 * 2, cButtonHeight_40)];
    _btnNext.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    _btnNext.layer.masksToBounds = YES;
    _btnNext.layer.cornerRadius = _btnNext.height/2;
    [_btnNext setTitle:LOCALIZATION(@"下一步") forState:UIControlStateNormal];
    [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnNext addTarget:self action:@selector(click_btnNext) forControlEvents:UIControlEventTouchUpInside];
    _btnNext.enabled = NO;
    [footerView addSubview:_btnNext];
    [_btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 86 * 2, cButtonHeight_40));
        make.left.mas_equalTo(footerView.mas_left).offset(86);
    }];
    return footerView;
}

@end
