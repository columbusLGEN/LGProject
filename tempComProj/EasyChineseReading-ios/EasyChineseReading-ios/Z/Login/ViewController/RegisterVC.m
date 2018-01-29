//
//  RegisterVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "RegisterVC.h"

#import "LTextFieldTableViewCell.h"
#import "LVerifyTableViewCell.h"
#import "RButtonTableViewCell.h"
#import "LPhoneTableViewCell.h"

#import "UserInfoAddressVC.h"
#import "RegisterSuccessVC.h"

@interface RegisterVC () <
UITableViewDelegate, UITableViewDataSource,
UITextFieldDelegate,
LTextFieldTableViewCellDelegate,
LVerifyTableViewCellDelegate,
RButtonTableViewCellDelegate,
ZPickViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *arrViewConfiguration;   // 界面配置

@property (assign, nonatomic) CGFloat keyBoardHeight;          // 键盘高度
@property (assign, nonatomic) CGFloat tableOffset;             // table 偏移量

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;  // 选中的cell

@property (strong, nonatomic) NSString *name;                  // 昵称
@property (strong, nonatomic) NSString *school;                // 学校
@property (strong, nonatomic) NSString *phone;                 // 手机号
@property (strong, nonatomic) NSString *email;                 // email
@property (strong, nonatomic) NSString *password;              // 密码
@property (strong, nonatomic) NSString *rePassword;            // 重复密码
@property (strong, nonatomic) NSString *code;                  // 验证码
@property (strong, nonatomic) NSString *user;                  // 账号
@property (strong, nonatomic) NSString *studentNum;            // 学习汉语学生数
@property (strong, nonatomic) NSString *strSchoolType;         // 学校类型(文本)
@property (assign, nonatomic) NSInteger country;               // 国家 id
@property (strong, nonatomic) NSString *areacode;              // 国家码
@property (strong, nonatomic) NSString *countryName;           // 国家名

@property (strong, nonatomic) NSArray *arrSchool;              // 学校类型数组

@property (assign, nonatomic) BOOL notScrollUnEnable;          // 滚动不取消第一响应

@property (assign, nonatomic) ENUM_SchoolType schoolType;      // 学校类型
@property (strong, nonatomic) ZPickView *pickSchool;           // 选择学校
@property (strong, nonatomic) ZSegment *segment;               // 选择注册类型

@property (strong, nonatomic) NSTimer *timer;                  // 计时器
@property (assign, nonatomic) NSInteger timeDown;              // 倒计时时间

@property (assign, nonatomic) ENUM_UserType userType;          // 注册类型

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configRegisterView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

#pragma mark - 配置登录界面

/** 配置注册界面 */
- (void)configRegisterView
{
    self.title = LOCALIZATION(@"用户注册");
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 默认使用首次注册选中的国家
    CountryModel *country = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_SelectCountry];
    _country = country.id;
    _countryName = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name;
    
    [self configHeaderView];
    [self configTableView];
}
/** 添加监听 */
- (void)addNotification
{
    // 监听 键盘出现或改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 监听 键盘退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/** 移除监听 */
- (void)removeNotification
{
    [self fk_removeObserver:UIKeyboardWillShowNotification];
    [self fk_removeObserver:UIKeyboardWillHideNotification];
}

/** 配置选择用户类别 */
- (void)configHeaderView
{
    _userType = ENUM_UserTypePerson;
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"个人用户") rightTitle:LOCALIZATION(@"机构用户")];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        [weakself updateRegisterTypeWithType:ENUM_UserTypePerson];
    };
    _segment.selectedRight = ^{
        [weakself updateRegisterTypeWithType:ENUM_UserTypeOrganization];
    };
}

/** 修改注册的用户类型 */
- (void)updateRegisterTypeWithType:(NSInteger)type
{
    _userType = type;
    [_tableView reloadData];
}

/** 配置注册界面 tableView */
- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LTextFieldTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LTextFieldTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LVerifyTableViewCell class])    bundle:nil] forCellReuseIdentifier:NSStringFromClass([LVerifyTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RButtonTableViewCell class])    bundle:nil] forCellReuseIdentifier:NSStringFromClass([RButtonTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LPhoneTableViewCell class])     bundle:nil] forCellReuseIdentifier:NSStringFromClass([LPhoneTableViewCell class])];
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
    if ([cell isKindOfClass:[LTextFieldTableViewCell class]]) {
        LTextFieldTableViewCell *txtfCell = (LTextFieldTableViewCell *)cell;
        txtfCell.delegate = self;
        if (txtfCell.txtfContent.tag == 20001) {
            txtfCell.txtfContent.text = _school;
        }
        else if (txtfCell.txtfContent.tag == 20003) {
            txtfCell.txtfContent.text = _studentNum;
        }
        else if (txtfCell.txtfContent.tag == 20005) {
            txtfCell.txtfContent.text = _name;
        }
        else if (txtfCell.txtfContent.tag == 20007) {
            txtfCell.txtfContent.text = _email;
        }
    }
    else if ([cell isKindOfClass:[RButtonTableViewCell class]]) {
        RButtonTableViewCell *btnCell = (RButtonTableViewCell *)cell;
        btnCell.delegate = self;
    }
    else if ([cell isKindOfClass:[LVerifyTableViewCell class]]) {
        LVerifyTableViewCell *verCell = (LVerifyTableViewCell *)cell;
        verCell.txtfContent.text = _code;
        verCell.delegate = self;
    }
    else if ([cell isKindOfClass:[LPhoneTableViewCell class]]) {
        LPhoneTableViewCell *pCell = (LPhoneTableViewCell *)cell;
        pCell.txtfAccount.text = _phone;
        pCell.selectedAreacode = ^{
            [self selectedCountryWithIndexPath:indexPath];
        };
    }
    
    [self configTextWithCell:cell];
    return cell;
}

#pragma mark - 获取 注册表 textfield 的值

/** 配置cell */
- (void)configTextWithCell:(UITableViewCell *)cell
{
    LTextFieldTableViewCell *tCell = (LTextFieldTableViewCell *)cell;
    LVerifyTableViewCell    *vCell = (LVerifyTableViewCell *)cell;
    LPhoneTableViewCell     *pCell = (LPhoneTableViewCell *)cell;
    if ([cell.reuseIdentifier isEqualToString:NSStringFromClass([LTextFieldTableViewCell class])]) {
        [tCell.txtfContent addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [tCell.txtfContent addTarget:self action:@selector(textFieldBeTouch:) forControlEvents:UIControlEventEditingDidBegin];
    }
    else if ([cell.reuseIdentifier isEqualToString:NSStringFromClass([LVerifyTableViewCell class])]) {
        [vCell.txtfContent addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [vCell.txtfContent addTarget:self action:@selector(textFieldBeTouch:) forControlEvents:UIControlEventEditingDidBegin];
    }
    else if ([cell.reuseIdentifier isEqualToString:NSStringFromClass([LPhoneTableViewCell class])]) {
        [pCell.txtfAccount addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [pCell.txtfAccount addTarget:self action:@selector(textFieldBeTouch:) forControlEvents:UIControlEventEditingDidBegin];
    }
}

/** 点击 textfield */
- (void)textFieldBeTouch:(UITextField *)textField
{
    // 选中的 textfield 所在的 cell 的 indexPath
    _selectedIndexPath = [NSIndexPath indexPathForRow:(textField.tag - 20001) inSection:0];
}

/** 改变textField里的值 */
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 10000: _user           = textField.text; break;
        case 10001: _password       = textField.text; break;
        case 10002: _rePassword     = textField.text; break;
        case 10003: _code           = textField.text; break;
        case 20001: _school         = textField.text; break;
        case 20002: _strSchoolType  = textField.text; break;
        case 20003: _studentNum     = textField.text; break;
        case 20005: _name           = textField.text; break;
        case 20006: _phone          = textField.text; break;
        case 20007: _email          = textField.text; break;
        case 20008: _code           = textField.text; break;
        default: break;
    }
    [self checkCanRegister];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果分配的数据有 showSelected ，那么点击这个cell 跳转选择国家
    if (_arrViewConfiguration[indexPath.row][@"showSelected"]) {
        if ([_arrViewConfiguration[indexPath.row][@"index"] isEqualToString:@"20002"]) {
            [self selectedSchoolType];
        }
        else if ([_arrViewConfiguration[indexPath.row][@"index"] isEqualToString:@"20004"]) {
            [self selectedCountryWithIndexPath:indexPath];
        }
    }
}

/** 选择学校类型 */
- (void)selectedSchoolType
{
    [self.view endEditing:YES];
    [self configPickViewSchool];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_notScrollUnEnable) {
        [self.view endEditing:YES];
    }
}

#pragma mark - LTextFieldTableViewCellDelegate

/** 选择国家 */
- (void)selectedCountry
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self selectedCountryWithIndexPath:indexPath];
}

/** 跳转选择国家列表界面 */
- (void)selectedCountryWithIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = [UserRequest sharedInstance].language;
    WeakSelf(self)
    // 选择完国家block回调
    addressVC.selectedCountryBlock = ^(CountryModel * country) {
        StrongSelf(self)
        if (self.userType == ENUM_UserTypeOrganization) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[LTextFieldTableViewCell class]]) { // 选择的是所在国家
                LTextFieldTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                cell.txtfContent.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name;
                _country = country.id;
                _countryName = cell.txtfContent.text;
            }
            else if ([cell isKindOfClass:[LPhoneTableViewCell class]]) { // 选择的是国家码（手机号前缀）
                LPhoneTableViewCell *pCell = [_tableView cellForRowAtIndexPath:indexPath];
                _areacode = country.areacode;
                [pCell updateAreacodeWithAreacode:country.areacode];
            }
        }
        else { // 选择的是国家码（手机号前缀）
            LPhoneTableViewCell *pCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            _areacode = country.areacode;
            [pCell updateAreacodeWithAreacode:country.areacode];
        }
        
        // 判断 如果必填数据未填写 则不能点击提交
        RButtonTableViewCell *cell = (RButtonTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_arrViewConfiguration.count - 1 inSection:0]];
        if ([cell isKindOfClass:[RButtonTableViewCell class]]) {
            if (_userType == ENUM_UserTypeOrganization)
                [cell updateButtonEnable:_school.length > 0 && _studentNum.length > 0 && _name.length > 0 && _phone.length > 0 && _email.length > 0 && _code.length > 0 && _areacode.length > 0];
            else
                [cell updateButtonEnable:_user.length > 0 && _areacode.length > 0 && _password.length > 0 && _rePassword.length > 0 && _code.length > 0];
        }
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

/** 选择学校 */
- (void)configPickViewSchool
{
    if (_pickSchool == nil) {
        _arrSchool = @[LOCALIZATION(@"小学"), LOCALIZATION(@"中学"), LOCALIZATION(@"大学"), LOCALIZATION(@"教育机构")];
        _pickSchool = [[ZPickView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_64 - cHeaderHeight_44) dataSource:_arrSchool selected:0];
        _pickSchool.delegates = self;
        [self.view addSubview:_pickSchool];
    }
    [_pickSchool show];
}

#pragma mark - LVerifyTableViewCellDelegate 发送验证码

- (void)sendVerifyCode
{
    if (_timeDown > 0) { return; }
    if (_userType == ENUM_UserTypeOrganization) {
        // 机构用户发送邮箱验证码
        if ([_email isEmail])
            [self sendEmailCodeWithEmail:_email];
        else
            [self presentFailureTips:LOCALIZATION(@"请输入正确格式的邮箱")];
    }
    else {
        if ([_user isEmail])
            [self sendEmailCodeWithEmail:_user];
        else if ([_user isNumber])
            [self sendPhoneCodeWithPhone:_user];
        else
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

/** 实现计时器事件 */
- (void)timerFireMethod:(NSTimer *)timer
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_userType == ENUM_UserTypeOrganization ? 7 : 3 inSection:0];
    
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

#pragma mark - ZPickViewDelegate

/** 确定选择 */
- (void)ZPickerView:(ZPickView *)picker makeSureIndex:(NSInteger)index
{
    _schoolType = index;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    LTextFieldTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.txtfContent.text = _arrSchool[index];
    
    [picker hidden];
}

/** 取消选择 */
- (void)ZPickerViewCancel:(ZPickView *)picker
{
    [_pickSchool hidden];
}

#pragma mark - RButtonTableViewCellDelegate 立即注册

/** 立即注册 */
- (void)registerNow
{
    [self checkRegisterInfomation];
}

#pragma mark - 注册流程

// ------------------------------------------------------------
//     普通用户                            机构用户
// |
// |--检查注册信息                  --检查注册信息
// |--验证账号唯一性（手机或邮箱）     --验证账号唯一性（手机与邮箱，验证两次）
// |  (返回0,1 0-可以使用的账号)       (返回0,1 0-可以使用的账号)
// |--发送验证码                   --发送验证码
// |--验证验证码                   --验证验证码
// |--提交注册信息                 --提交注册信息
// |--登录（获取用户信息）           --登录（获取用户信息）
// |--注册成功                     --注册成功
// -------------------------------------------------------------

#pragma mark 检查注册信息
- (void)checkRegisterInfomation
{
    // 判断账号类型（手机 邮箱）
    NSString *accountType = @"";

    // 检查 emoji
    if ([NSString stringContainsEmoji:_user] ||
        [NSString stringContainsEmoji:_phone] ||
        [NSString stringContainsEmoji:_email] ||
        [NSString stringContainsEmoji:_school] ||
        [NSString stringContainsEmoji:_studentNum] ||
        [NSString stringContainsEmoji:_name] ||
        [NSString stringContainsEmoji:_code]) {
        [self presentFailureTips:LOCALIZATION(@"不能输入emoji表情")];
        return;
    }
    
    // 验证码检查
    if ([_code empty]) {
        [self presentFailureTips:LOCALIZATION(@"请输入验证码")];
        return;
    }
    if (![_code isNumber]) {
        [self presentFailureTips:LOCALIZATION(@"请输入正确的验证码")];
        return;
    }
    
    // 国家码必须选择, 即使个人用户注册的是手机号
    if ([_areacode empty]) {
        [self presentFailureTips:LOCALIZATION(@"国家码不能为空")];
        return;
    }
    
    // 检查账号格式是否正确
    if (_user.length > 0) {
        if ([_user isEmail]) {
            accountType = [NSString stringWithFormat:@"%lu", (unsigned long)ENUM_AccountTypeEmail];
            _email = _user;
            _phone = @"";
        }
        else if ([_user isNumber]) {
            accountType = [NSString stringWithFormat:@"%lu", (unsigned long)ENUM_AccountTypePhone];
            _phone = _user;
            _email = @"";
        }
        else {
            [self presentFailureTips:LOCALIZATION(@"账号类型错误，账号为手机/邮箱号")];
            return;
        }
    }
    
    //机构用户注册信息检查
    if (_userType == ENUM_UserTypeOrganization) {
        // 检查特殊字符
        if ([NSString stringContainsIllegalCharacter:_name]) {
            [self presentFailureTips:[NSString stringWithFormat:@"%@%@", LOCALIZATION(@"申请人姓名"), LOCALIZATION(@"不能输入特殊符号")]];
            return;
        }
        // 检查字符超限
        if (_name.charLength > cMaxNameLength) {
            [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"申请人姓名"),LOCALIZATION(@"字符长度为"), cMaxNameLength]];
            return;
        }
        if (_school.charLength > cMaxSchoolLength) {
            [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"学校/机构名称"),LOCALIZATION(@"字符长度为"), cMaxSchoolLength]];
            return;
        }
        // 手机号非空检查
        if ([NSString isEmpty:_phone]) {
            [self presentFailureTips:LOCALIZATION(@"手机号不能为空")];
            return;
        }
        // 手机号格式检查
        if (![_phone isNumber]) {
            [self presentFailureTips:LOCALIZATION(@"手机号格式不对，请重新输入")];
            return;
        }
        // 邮箱非空检查
        if ([NSString isEmpty:_email]) {
            [self presentFailureTips:LOCALIZATION(@"邮箱号不能为空")];
            return;
        }
        // 邮箱格式检查
        if (![_email isEmail]) {
            [self presentFailureTips:LOCALIZATION(@"邮箱号格式不对，请重新输入")];
            return;
        }
        // 学校非空检查
        if ([NSString isEmpty:_school]) {
            [self presentFailureTips:LOCALIZATION(@"学校不能为空")];
            return;
        }
        // 申请人姓名检查
        if ([NSString isEmpty:_name]) {
            [self presentFailureTips:LOCALIZATION(@"申请人姓名不能为空")];
            return;
        }
        // 学生数只能是数字
        if (![_studentNum isNumber]) {
            [self presentFailureTips:LOCALIZATION(@"学生数量只能输入数字")];
            return;
        }
    }
    // 普通用户注册信息检查
    else {
        if ([NSString isEmpty:_user]) {
            [self presentFailureTips:LOCALIZATION(@"账号不能为空")];
            return;
        }
        // 密码检查（密码只有普通用户有，机构用户是由管理员分配）
        if ([_password notPassword]) {
            [self presentFailureTips:LOCALIZATION(@"密码为8-16个字符，由英文、数字组成")];
        }
        if (![_password isEqualToString:_rePassword]) {
            [self presentFailureTips:LOCALIZATION(@"两次输入的密码不一样，请确认后重新输入")];
            return;
        }
    }
    
    [self verifyAccountSingleWithAccountType:accountType];
}

#pragma mark 验证账号的唯一性
// accountType 账号类型（手机 邮箱）（下面同理）
- (void)verifyAccountSingleWithAccountType:(NSString *)accountType
{
    [self showWaitTips];
    if (_userType == ENUM_UserTypePerson)
        [self personVerifySingleWithAccountType:accountType];
    else
        [self organizationVerifySingleWithPhone];
}

#pragma mark 普通用户验证账号唯一性
- (void)personVerifySingleWithAccountType:(NSString *)accountType
{
    WeakSelf(self)
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:_user userType:accountType completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self dismissTips];
            [self presentFailureTips:error.message];
        }
        else {
            // 数据中没有该账号 可以使用
            [self checkVerifyCodeWithAccountType:accountType];
        }
    }];
}

#pragma mark 机构用户验证手机的唯一性
- (void)organizationVerifySingleWithPhone
{
    WeakSelf(self)
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:_phone userType:[NSString stringWithFormat:@"%ld", ENUM_AccountTypePhone] completion:^(id object, ErrorModel *error) {
        if (error) {
            [weakself presentFailureTips:error.message];
        }
        else {
            // 数据中没有该账号 可以使用
            [weakself organizationVerifySingleWithEmail];
        }
        
    }];
}

#pragma mark 机构用户验证邮箱的唯一性
- (void)organizationVerifySingleWithEmail
{
    WeakSelf(self)
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:_email userType:[NSString stringWithFormat:@"%ld", ENUM_AccountTypeEmail] completion:^(id object, ErrorModel *error) {
        if (error) {
            [weakself presentFailureTips:error.message];
        }
        else {
            // 数据中没有该账号 可以使用
            [weakself checkVerifyCodeWithAccountType:[NSString stringWithFormat:@"%ld", ENUM_AccountTypeEmail]];
        }
    }];
}

#pragma mark 发送邮箱验证码
- (void)sendEmailCodeWithEmail:(NSString *)email
{
    [self configTimer];
    WeakSelf(self)
    [[UserRequest sharedInstance] sendEmailCodeWithEmail:email completion:^(id object, ErrorModel *error) {
        if (error) {
            [weakself presentFailureTips:error.message];
        }
    }];
}

#pragma mark 发送手机验证码
- (void)sendPhoneCodeWithPhone:(NSString *)phone
{
    [self configTimer];
}

#pragma mark 验证验证码
- (void)checkVerifyCodeWithAccountType:(NSString *)accountType
{
    WeakSelf(self)
    [[UserRequest sharedInstance] verityCodeWithType:accountType verifi:_code account:_userType == ENUM_UserTypeOrganization ? _email : _user completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self showWaitTips];
            [self presentFailureTips:error.message];
        }
        else
            [self registerRequestWithAccountType:accountType];
    }];
}

#pragma mark 提交注册信息
- (void)registerRequestWithAccountType:(NSString *)accountType
{
    WeakSelf(self)
    [[UserRequest sharedInstance] registerUserWithType:accountType
                                              userType:[NSString stringWithFormat:@"%ld", (long)_userType]
                                              password:_password
                                                school:_school
                                            schoolType:[NSString stringWithFormat:@"%ld", _schoolType]
                                            learnChNum:_studentNum
                                               country:[NSString stringWithFormat:@"%ld", _country]
                                                  name:_name
                                                 email:_email
                                                 phone:_phone
                                              areacode:_areacode
                                           countryName:_countryName
                                            completion:^(id object, ErrorModel *error) {
                                                StrongSelf(self)
                                                if (error) {
                                                    [self dismissTips];
                                                    [self presentFailureTips:error.message];
                                                }
                                                else {
                                                    if (_userType == ENUM_UserTypePerson)
                                                        [self loginWithAccountType:accountType];
                                                    else
                                                        [self registerSuccessWithType:ENUM_UserTypeOrganization];
                                                }
                                            }];
}

#pragma mark 根据账号类型登录
- (void)loginWithAccountType:(NSString *)accountType
{
    WeakSelf(self)
    [[UserRequest sharedInstance] loginWithType:[NSString stringWithFormat:@"%ld", (long)ENUM_LoginTypePassword]
                                       userType:accountType
                                           user:_user
                                       password:_password
                                         userId:@""
                                          token:@""
                                    accountType:@"0"
                                     completion:^(id object, ErrorModel *error) {
                                         StrongSelf(self)
                                         if (error) {
                                             [self presentFailureTips:error.message];
                                         }
                                         else {
                                             if ([object isKindOfClass:[NSDictionary class]]) {
                                                 [self registerSuccessWithType:ENUM_UserTypePerson];
                                             }
                                         }
                                     }];
}

#pragma mark 注册成功
- (void)registerSuccessWithType:(ENUM_UserType)type
{
    RegisterSuccessVC *rSuccessVC = [RegisterSuccessVC new];
    rSuccessVC.userType = type;
    [self.navigationController pushViewController:rSuccessVC animated:YES];
}

#pragma mark - 监听键盘
// 键盘出现或改变
- (void)keyboardWillShow:(NSNotification *)notification
{
    // 获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    // textfield 所在的 cell
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    // 滚动不取消第一响应
    _notScrollUnEnable = YES;
    if (cell.y + cell.height > self.view.height - _keyBoardHeight) {
        _tableOffset = (cell.y + cell.height) - self.view.height + _keyBoardHeight;
        _tableView.frame = CGRectMake(0, -_tableOffset, Screen_Width, self.view.height);
    }
    // 取消滚动不取消第一响应
    _notScrollUnEnable = NO;
}

// 键盘退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    _tableView.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - 2*cHeaderHeight_44);
}

#pragma mark - 检查是否可以开始注册(注册按键是否可以点击)
- (void)checkCanRegister
{
    // 判断 如果必填数据未填写 则不能点击提交
    RButtonTableViewCell *cell = (RButtonTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_arrViewConfiguration.count - 1 inSection:0]];
    if ([cell isKindOfClass:[RButtonTableViewCell class]]) {
        if (_userType == ENUM_UserTypeOrganization)
            [cell updateButtonEnable:_school.length > 0 && _studentNum.length > 0 && _name.length > 0 && _phone.length > 0 && _email.length > 0 && _code.length > 0 && _areacode.length > 0];
        else
            [cell updateButtonEnable:_user.length > 0 && _areacode.length > 0 && _password.length > 0 && _rePassword.length > 0 && _code.length > 0];
    }
}

#pragma mark - 属性
- (NSArray *)arrViewConfiguration
{
    if (_userType == ENUM_UserTypeOrganization) {
        _arrViewConfiguration = @[@{@"index": @"20001", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": LOCALIZATION(@"学校/机构名称"), @"icon": @"icon_register_school"},
                                  @{@"index": @"20002", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": LOCALIZATION(@"学校类型"), @"icon": @"icon_register_sub_number", @"showSelected": @(1), @"content": LOCALIZATION(@"小学")},
                                  @{@"index": @"20003", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": LOCALIZATION(@"学习汉语学生数"), @"icon": @"icon_register_sub_number"},
                                  @{@"index": @"20004", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": LOCALIZATION(@"所在国家或地区"), @"icon": @"icon_register_country", @"showSelected": @(1), @"content": _countryName},
                                  @{@"index": @"20005", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": LOCALIZATION(@"申请人姓名"), @"icon": @"icon_register_sub_number"},
                                  @{@"index": @"20006", @"identify": NSStringFromClass([LPhoneTableViewCell class]),     @"placeHolder": LOCALIZATION(@"联系电话"), @"icon": @"icon_register_account", @"isPhone": @"1"},
                                  @{@"index": @"20007", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": LOCALIZATION(@"联系邮箱"), @"icon": @"icon_register_email", @"isEmail": @"1"},
                                  @{@"index": @"20008", @"identify": NSStringFromClass([LVerifyTableViewCell class]),    @"placeHolder": LOCALIZATION(@"请输入验证码"), @"icon": @"icon_register_verification", @"btnText": LOCALIZATION(@"获取邮箱验证码")},
                                  @{@"index": @"20009", @"identify": NSStringFromClass([RButtonTableViewCell class])}];
    }
    else {
        _arrViewConfiguration = @[@{@"index": @"10000", @"identify": NSStringFromClass([LPhoneTableViewCell class]),     @"placeHolder": LOCALIZATION(@"邮箱/手机号"), @"icon": @"icon_login_user_account"},
                                  @{@"index": @"10001", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": [NSString stringWithFormat:@"%@", LOCALIZATION(@"输入密码")], @"icon": @"icon_login_password", @"password": @"1"},
                                  @{@"index": @"10002", @"identify": NSStringFromClass([LTextFieldTableViewCell class]), @"placeHolder": LOCALIZATION(@"确认密码"), @"icon": @"icon_login_password", @"password": @"1"},
                                  @{@"index": @"10003", @"identify": NSStringFromClass([LVerifyTableViewCell class]),    @"placeHolder": LOCALIZATION(@"请输入验证码"), @"icon": @"icon_register_verification", @"btnText": LOCALIZATION(@"获取验证码")},
                                  @{@"index": @"10004", @"identify": NSStringFromClass([RButtonTableViewCell class])}];
    }
    return _arrViewConfiguration;
}

@end
