//
//  RegisterWeChatUserVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/31.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "RegisterWeChatUserVC.h"

#import "LVerifyTableViewCell.h"
#import "RButtonTableViewCell.h"
#import "LPhoneTableViewCell.h"

#import "RegisterSuccessVC.h"
#import "UserInfoAddressVC.h"

@interface RegisterWeChatUserVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RButtonTableViewCellDelegate, LVerifyTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *arrViewConfiguration;   // 界面配置

@property (strong, nonatomic) NSString *password;              // 密码
@property (strong, nonatomic) NSString *rePassword;            // 重复密码
@property (strong, nonatomic) NSString *code;                  // 验证码
@property (strong, nonatomic) NSString *account;               // 账号
@property (strong, nonatomic) NSString *areacode;              // 国家码

@property (assign, nonatomic) BOOL sendCode;                   // 发送了验证码

@property (strong, nonatomic) NSTimer *timer;                  // 计时器
@property (assign, nonatomic) NSInteger timeDown;              // 倒计时时间

@property (assign, nonatomic) ENUM_AccountType accountType;    // 注册类型

@end

@implementation RegisterWeChatUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"微信注册");
}

- (void)baseViewControllerDismiss
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height - cHeaderHeight_44 - cHeaderHeight_64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LVerifyTableViewCell    class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LVerifyTableViewCell    class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RButtonTableViewCell    class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RButtonTableViewCell    class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LPhoneTableViewCell     class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LPhoneTableViewCell     class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrViewConfiguration.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_arrViewConfiguration[indexPath.row][@"identify"]];
    cell.data = _arrViewConfiguration[indexPath.row];
    if ([cell isKindOfClass:[RButtonTableViewCell class]]) {
        RButtonTableViewCell *btnCell = (RButtonTableViewCell *)cell;
        btnCell.delegate = self;
    }
    else if ([cell isKindOfClass:[LVerifyTableViewCell class]]) {
        LVerifyTableViewCell *verCell = (LVerifyTableViewCell *)cell;
        verCell.delegate = self;
    }
    else if ([cell isKindOfClass:[LPhoneTableViewCell class]]) {
        LPhoneTableViewCell *pCell = (LPhoneTableViewCell *)cell;
        pCell.selectedAreacode = ^{
            [self toSelectCountry];
        };
    }
    
    [self configTextWithCell:cell];
    return cell;
}

#pragma mark - 选择国家

/** 选择国家 */
- (void)toSelectCountry
{
    LPhoneTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = [UserRequest sharedInstance].language;
    WeakSelf(self)
    addressVC.selectedCountryBlock = ^(CountryModel * country) {
        StrongSelf(self)
        self.areacode = country.areacode;
        [cell updateAreacodeWithAreacode:country.areacode];
        
        // 判断是否满足注册条件
        RButtonTableViewCell *cell = (RButtonTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if ([cell isKindOfClass:[RButtonTableViewCell class]]) {
            [cell updateButtonEnable:_account.length > 0 && _code.length > 0 && _sendCode];
        }
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark - 获取 注册表 textfield 的值

- (void)configTextWithCell:(UITableViewCell *)cell
{
    LVerifyTableViewCell    *vCell = (LVerifyTableViewCell *)cell;
    LPhoneTableViewCell     *pCell = (LPhoneTableViewCell *)cell;

    if ([cell.reuseIdentifier isEqualToString:NSStringFromClass([LVerifyTableViewCell class])]) {
        vCell.txtfContent.delegate = self;
        [vCell.txtfContent addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }
    else if ([cell.reuseIdentifier isEqualToString:NSStringFromClass([LPhoneTableViewCell class])]) {
        pCell.txtfAccount.delegate = self;
        [pCell.txtfAccount addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 10000: _account = textField.text; break;
        case 10003: _code = textField.text;    break;
        default:
            break;
    }
    
    // 判断是否满足注册条件
    RButtonTableViewCell *cell = (RButtonTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if ([cell isKindOfClass:[RButtonTableViewCell class]]) {
        [cell updateButtonEnable:_account.length > 0 && _code.length > 0 && _sendCode];
    }
}

#pragma mark - LVerifyTableViewCellDelegate 发送验证码
- (void)sendVerifyCode
{
    // 已经发送过验证码 未到过期时间
    if (_timeDown > 0) {
        return;
    }
    
    RButtonTableViewCell *cell = (RButtonTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    // 判断是否满足注册条件 及 根据注册类型发送不同渠道的验证码
    if ([_account isEmail]) {
        _sendCode = YES;
        if ([cell isKindOfClass:[RButtonTableViewCell class]])
            [cell updateButtonEnable:_account.length > 0 && _code.length > 0 && _sendCode];
        
        [self sendEmailCodeWithEmail:_account];
    }
    else if ([_account isNumber]) {
        if (_areacode.length > 0) {
            _sendCode = YES;
            if ([cell isKindOfClass:[RButtonTableViewCell class]])
                [cell updateButtonEnable:_account.length > 0 && _code.length > 0 && _sendCode];
            
            [self sendPhoneCodeWithPhone:_account areacode:_areacode];
        }
        else {
            [self presentFailureTips:LOCALIZATION(@"国家码不能为空")];
        }
    }
    else {
        [self presentFailureTips:LOCALIZATION(@"请输入正确格式的手机号或邮箱")];
    }
    
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

#pragma mark - RButtonTableViewCellDelegate
/** 立刻注册 */
- (void)registerNow
{
    [self checkVerifyCodeWithAccountType:_accountType];
}

#pragma mark -

/** 发送邮箱验证码 */
- (void)sendEmailCodeWithEmail:(NSString *)email
{
    [self configTimer];
    _accountType = ENUM_AccountTypeEmail;
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
    [self configTimer];
    _accountType = ENUM_AccountTypePhone;
    WeakSelf(self)
    [[UserRequest sharedInstance] sendPhoneCodeWithPhone:phone areacode:areacode completion:^(id object, ErrorModel *error) {
        if (error) {
            [weakself presentFailureTips:error.message];
        }
    }];
}

/** 验证验证码 */
- (void)checkVerifyCodeWithAccountType:(ENUM_AccountType)accountType
{
    [self showWaitTips];
    // 检查账号信息非空
    if (_account == nil || [_account empty]) {
        [self presentFailureTips:LOCALIZATION(@"请输入邮箱/手机号作为账号")];
        return;
    }
    // 检查验证码非空
    if (_code == nil || [_code empty]) {
        [self presentFailureTips:LOCALIZATION(@"请输入验证码")];
        return;
    }
    WeakSelf(self)
    [[UserRequest sharedInstance] verityCodeWithType:[NSString stringWithFormat:@"%ld", accountType]
                                              verifi:_code
                                             account:_account
                                          completion:^(id object, ErrorModel *error) {
                                              StrongSelf(self)
                                              if (error) {
                                                  [self dismissTips];
                                                  [self presentFailureTips:error.message];
                                              }
                                              else {
                                                  [self registerWeChatWithType:_accountType];
                                              }
                                          }];
}

/** 通过微信账号绑定账号 */
- (void)registerWeChatWithType:(ENUM_AccountType)accountType
{
    WeakSelf(self)
    [[UserRequest sharedInstance] registerWithWeChatInfo:_userDic
                                                   phone:accountType == ENUM_AccountTypePhone ? _account : @""
                                                   email:accountType == ENUM_AccountTypeEmail ? _account : @""
                                                areacode:_areacode
                                                    type:accountType
                                              completion:^(id object, ErrorModel *error) {
                                                  StrongSelf(self)
                                                  [self dismissTips];
                                                  if (error) {
                                                      [self presentFailureTips:error.message];
                                                  }
                                                  else {
                                                      NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
                                                      if ([array.firstObject isKindOfClass:[NSDictionary class]]) {
                                                          NSDictionary *dic = array.firstObject;
                                                          UserModel *user = [UserModel mj_objectWithKeyValues:dic[@"user"]];
                                                          [UserRequest sharedInstance].user = user;
                                                          [UserRequest sharedInstance].token = dic[@"token"];
                                                          [[UserRequest sharedInstance] saveCache];
                                                          [self fk_postNotification:kNotificationUserLogin];
                                                          [self registerSuccessWithType:ENUM_UserTypePerson];
                                                      }
                                                  }
                                              }];
}

/** 注册成功 */
- (void)registerSuccessWithType:(ENUM_UserType)userType
{
    RegisterSuccessVC *rSuccessVC = [RegisterSuccessVC new];
    rSuccessVC.userType = userType;
    [self.navigationController pushViewController:rSuccessVC animated:YES];
}

#pragma mark - 属性

- (NSArray *)arrViewConfiguration
{
    if (_arrViewConfiguration == nil) {
        _arrViewConfiguration = @[@{@"index": @"10000", @"identify": NSStringFromClass([LPhoneTableViewCell  class]), @"placeHolder": LOCALIZATION(@"邮箱/手机号"), @"icon": @"icon_register_account"},
                                  @{@"index": @"10003", @"identify": NSStringFromClass([LVerifyTableViewCell class]), @"placeHolder": LOCALIZATION(@"请输入验证码"), @"icon": @"icon_register_verification"},
                                  @{@"index": @"10004", @"identify": NSStringFromClass([RButtonTableViewCell class])}];
    }
    return _arrViewConfiguration;
}

@end
