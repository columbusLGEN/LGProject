//
//  ForgotPasswordVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ForgotPasswordVC.h"

#import "LPhoneTableViewCell.h"
#import "LTextFieldTableViewCell.h"
#import "LVerifyTableViewCell.h"

#import "USecurityCenterUpdateVC.h"
#import "UserInfoAddressVC.h"

static CGFloat const kFooterHeight = 150.f; // tableViewFooter 的高度

#define kPhoneCell     NSStringFromClass([LPhoneTableViewCell class])
#define kTextFieldCell NSStringFromClass([LTextFieldTableViewCell class])
#define kVerifyCell    NSStringFromClass([LVerifyTableViewCell class])

@interface ForgotPasswordVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LVerifyTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
/** 界面配置 */
@property (strong, nonatomic) NSArray *arrViewConfiguration;

/** 手机号 */
@property (strong, nonatomic) NSString *phone;
/** 邮箱*/
@property (strong, nonatomic) NSString *email;
/** 国家手机码 */
@property (strong, nonatomic) NSString *areacode;
/** 验证码 */
@property (strong, nonatomic) NSString *code;
/** 用户id */
@property (assign, nonatomic) NSInteger userId;
/** 计时器 */
@property (strong, nonatomic) NSTimer *timer;
/** 倒计时时间 */
@property (assign, nonatomic) NSInteger timeDown;

@property (strong, nonatomic) UIButton *btnNext;

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置登录界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"忘记密码");
}

- (void)updateAccountType:(NSInteger)type
{
    _accountType = type;
    [_tableView reloadData];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height - cHeaderHeight_64 - cHeaderHeight_44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:kTextFieldCell bundle:nil] forCellReuseIdentifier:kTextFieldCell];
    [_tableView registerNib:[UINib nibWithNibName:kVerifyCell    bundle:nil] forCellReuseIdentifier:kVerifyCell];
    [_tableView registerNib:[UINib nibWithNibName:kPhoneCell     bundle:nil] forCellReuseIdentifier:kPhoneCell];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrViewConfiguration.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_arrViewConfiguration[indexPath.row][@"identify"]];
    cell.data = _arrViewConfiguration[indexPath.row];
    
    if ([cell isKindOfClass:[LPhoneTableViewCell class]]) {
        LPhoneTableViewCell *pCell = (LPhoneTableViewCell *)cell;
        pCell.selectedAreacode = ^{
            [self toSelectCountry];
        };
    }
    else if ([cell isKindOfClass:[LTextFieldTableViewCell class]]) {
        
    }
    else {
        LVerifyTableViewCell *bCell = (LVerifyTableViewCell *)cell;
        bCell.delegate = self;
    }
    
    [self configTextWithCell:cell];
    return cell;
}

#pragma mark - action

- (void)configTextWithCell:(UITableViewCell *)cell
{
    if ([cell.reuseIdentifier isEqualToString:NSStringFromClass([LTextFieldTableViewCell class])]) {
        LTextFieldTableViewCell *tCell = (LTextFieldTableViewCell *)cell;
        [tCell.txtfContent addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }
    else if ([cell.reuseIdentifier isEqualToString:NSStringFromClass([LPhoneTableViewCell class])]) {
        LPhoneTableViewCell *pCell = (LPhoneTableViewCell *)cell;
        [pCell.txtfAccount addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }
    else {
        LVerifyTableViewCell *vCell = (LVerifyTableViewCell *)cell;
        [vCell.txtfContent addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 100: _phone = textField.text; break;
        case 150: _email = textField.text; break;
        case 200: _code  = textField.text; break;
        default: break;
    }
    // 满足下一步的条件
    BOOL canNext = ((_phone.length > 0 && _areacode.length > 0) || _email.length > 0) && _code.length > 0;
    _btnNext.enabled = canNext;
    _btnNext.backgroundColor = canNext ? [UIColor cm_mainColor] : [UIColor cm_grayColor__F1F1F1_1];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    
    _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(86, 100, Screen_Width - 86*2, cHeaderHeight_44)];
    [_btnNext setTitle:LOCALIZATION(@"下一步") forState:UIControlStateNormal];
    [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnNext addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    _btnNext.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    _btnNext.enabled = NO;
    
    _btnNext.layer.masksToBounds = YES;
    _btnNext.layer.cornerRadius = _btnNext.height/2;
    
    [footer addSubview:_btnNext];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kFooterHeight;
}

#pragma mark - 选择国家

/** 选择国家 */
- (void)toSelectCountry
{
    LPhoneTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = [UserRequest sharedInstance].language;
    WeakSelf(self)
    addressVC.selectedCountryBlock = ^(CountryModel * country){
        weakself.areacode = country.areacode;
        [cell updateAreacodeWithAreacode:country.areacode];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark - LVerifyTableViewCellDelegate 发送验证码
/** 发送验证码前的验证 */
- (void)sendVerifyCode
{
    if (_accountType == ENUM_AccountTypePhone) {
        if (![_phone isNumber]) {
            [self presentFailureTips:LOCALIZATION(@"请输入正确格式的手机号")];
            return;
        }
        if ([_areacode empty]) {
            [self presentFailureTips:LOCALIZATION(@"国家码不能为空")];
            return;
        }
    }
    else {
        if (![_email isEmail]) {
            [self presentFailureTips:LOCALIZATION(@"请输入正确格式的邮箱")];
            return;
        }
    }
    
    [self checkHasAccount];
}

/** 验证是否有账号 */
- (void)checkHasAccount
{
    [self showWaitTips];
    WeakSelf(self)
    NSString *account = _accountType == ENUM_AccountTypePhone ? _phone : _email;
    NSString *accountType = [NSString stringWithFormat:@"%ld", _accountType];
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:account userType:accountType completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {// 如果 error.code 返回1 则证明有账号
            if (error.code == 1) {
                NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
                NSDictionary *dic = array.firstObject;
                NSNumber *number = dic[@"userId"];
                _userId = number.integerValue;
                [self sendingCode];
            }
            else {
                [self presentFailureTips:error.message];
            }
        }
        else {// 如果没有报错 则证明没有账号
            [self presentFailureTips:LOCALIZATION(@"账号不存在, 请检查后重新输入")];
        }
    }];
}

/** 发送验证码 */
- (void)sendingCode
{
    if (_timeDown > 0)
        return;
    
    if (_accountType == ENUM_AccountTypeEmail) {
        if ([_email isEmail])
            [self sendEmailCodeWithEmail:_email];
        else
            [self presentFailureTips:LOCALIZATION(@"请输入正确格式的邮箱")];
    }
    else {
        if ([_phone isNumber])
            [self sendPhoneCodeWithPhone:_phone];
        else
            [self presentFailureTips:LOCALIZATION(@"请输入正确格式的手机号")];
    }
}

/** 发送邮箱验证码 */
- (void)sendEmailCodeWithEmail:(NSString *)email
{
    [self configTimer];
    WeakSelf(self)
    [[UserRequest sharedInstance] sendEmailCodeWithEmail:email completion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
    }];
}

/** 发送手机验证码 */
- (void)sendPhoneCodeWithPhone:(NSString *)phone
{
    [self configTimer];
    WeakSelf(self)
    [[UserRequest sharedInstance] sendPhoneCodeWithPhone:phone areacode:_areacode completion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
    }];
}

#pragma mark - 点击下一步
- (void)clickNext
{
    if ((_phone.length > 0 || _email.length > 0) && _code.length > 0)
        [self checkVerifyCode];
}

/** 验证验证码 */
- (void)checkVerifyCode
{
    [self showWaitTips];
    WeakSelf(self)
    NSString *accountType = [NSString stringWithFormat:@"%ld", _accountType];
    NSString *account = _accountType == ENUM_AccountTypePhone ? _phone : _email;
    [[UserRequest sharedInstance] verityCodeWithType:accountType verifi:_code account:account completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error)
            [self presentFailureTips:error.message];
        else
            [self toNextViewController];
    }];
}

// 跳转下一个界面
- (void)toNextViewController
{
    // 修改密码界面
    USecurityCenterUpdateVC *updateVC = [[USecurityCenterUpdateVC alloc] init];
    updateVC.securityCenterUpdateType = ENUM_ZUserSecurityCenterUpdateMethodForget;
    updateVC.accountType = _accountType;
    updateVC.account = _accountType == ENUM_AccountTypePhone ? _phone : _email;
    updateVC.areacode = _areacode;
    [self.navigationController pushViewController:updateVC animated:YES];
}


#pragma mark - 配置计时器

/** 配置计时器 */
- (void)configTimer
{
    // 倒计时 60s
    _timeDown = 60;
    // 每秒更新一次倒计时
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}


/** 实现计时器方法 */
- (void)timerFireMethod:(NSTimer *)timer
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    LVerifyTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (_timeDown > 0) {
        _timeDown -= 1;
        cell.sendVerify.userInteractionEnabled = NO;
        [cell.sendVerify setTitle:[NSString stringWithFormat:@"%ld", _timeDown] forState:UIControlStateNormal];
    }
    else {
        cell.sendVerify.userInteractionEnabled = YES;
        [cell.sendVerify setTitle:LOCALIZATION(@"获取验证码") forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 界面配置的数组属性

- (NSArray *)arrViewConfiguration
{
    if (_accountType == ENUM_AccountTypePhone) {
        _arrViewConfiguration = @[@{@"index": @"100", @"identify": kPhoneCell,  @"placeHolder": LOCALIZATION(@"手机号"), @"icon": @"icon_login_user_account"},
                                  @{@"index": @"200", @"identify": kVerifyCell, @"placeHolder": LOCALIZATION(@"请输入验证码"), @"icon": @"icon_register_verification"}];
    }
    else {
        _arrViewConfiguration = @[@{@"index": @"150", @"identify": kTextFieldCell, @"placeHolder": LOCALIZATION(@"邮箱号"), @"icon": @"icon_login_user_account"},
                                  @{@"index": @"200", @"identify": kVerifyCell,    @"placeHolder": LOCALIZATION(@"请输入验证码"), @"icon": @"icon_register_verification"}];
    }
    return _arrViewConfiguration;
}

@end
