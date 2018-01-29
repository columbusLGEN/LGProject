//
//  UCTeacherMangerVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCTeacherManagerVC.h"

#import "UserInfoAddressVC.h"

@interface UCTeacherManagerVC () <UITextFieldDelegate, UITextViewDelegate, ZPickViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDescName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescSex;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAge;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAccount;    // 账号 包括 phone/email
@property (weak, nonatomic) IBOutlet UILabel *lblDescPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblDescRePassword;
@property (weak, nonatomic) IBOutlet UILabel *lblDescRemark;

@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblRemarkPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxRemarkLength;

@property (weak, nonatomic) IBOutlet UIImageView *imgSex;

@property (weak, nonatomic) IBOutlet UITextField *txtfName;
@property (weak, nonatomic) IBOutlet UITextField *txtfAge;
@property (weak, nonatomic) IBOutlet UITextField *txtfAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtfAreacode;
@property (weak, nonatomic) IBOutlet UITextField *txtfPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtfRePassword;

@property (weak, nonatomic) IBOutlet UITextView *txtRemark;

@property (strong, nonatomic) ZPickView *pickViewSex; // 性别选择器

@property (strong, nonatomic) NSArray *arrSex;             // 性别数组
@property (strong, nonatomic) NSMutableArray *arrTeachers; // 教师数组

@property (assign, nonatomic) NSInteger sex;                // 性别
@property (assign, nonatomic) ENUM_AccountType accountType; // 账号类型

@end

@implementation UCTeacherManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    // 修改教师界面
    if (_isEdit) {
        [self configData];
    }
    _lblMaxRemarkLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtRemark.text.charLength, cMaxClassDescLength];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidChangeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)updateSystemLanguage
{
    self.title = _isEdit ? LOCALIZATION(@"修改教师") : LOCALIZATION(@"创建教师");
    
    _lblDescName.text       = LOCALIZATION(@"姓名");
    _lblDescSex.text        = LOCALIZATION(@"性别");
    _lblDescAge.text        = LOCALIZATION(@"年龄");
    _lblDescAccount.text    = LOCALIZATION(@"账号");
    _lblDescRemark.text     = LOCALIZATION(@"备注");
    _lblDescPassword.text   = LOCALIZATION(@"密码");
    _lblDescRePassword.text = LOCALIZATION(@"确认密码");
    _lblSex.text            = LOCALIZATION(@"男");
    _lblRemarkPlaceholder.text = [NSString stringWithFormat:@"%@ %ld", LOCALIZATION(@"字符长度为"), cMaxClassDescLength];

    _txtfName.placeholder       = [NSString stringWithFormat:@"%@ %ld", LOCALIZATION(@"字符长度为"), cMaxNameLength];
    _txtfAge.placeholder        = LOCALIZATION(@"请输入教师年龄");
    _txtfAccount.placeholder    = LOCALIZATION(@"手机号/邮箱");
    _txtfAreacode.placeholder   = _isEdit ? @"" : LOCALIZATION(@"国家码");
    _txtfPassword.placeholder   = [NSString stringWithFormat:@"%@", LOCALIZATION(@"输入密码")];
    _txtfRePassword.placeholder = LOCALIZATION(@"再次输入密码");
    
    [self.tableView reloadData];
}

#pragma mark - 配置界面数据

- (void)configData
{
    _txtfName.text    = _teacher.name;
    _lblSex.text      = _teacher.sex == ENUM_SexTypeMan ? LOCALIZATION(@"男") : LOCALIZATION(@"女");
    _txtfAge.text     = [NSString stringWithFormat:@"%ld", _teacher.age];
    _txtfAccount.text = _teacher.phone.length > 0 ? [NSString stringWithFormat:@"+%ld %@", _teacher.areacode, _teacher.phone] : _teacher.email;
    _txtRemark.text   = _teacher.remark;
    _lblRemarkPlaceholder.hidden = _txtRemark.text.length > 0;
}

- (void)configView
{
    [self configNavigationBar];
    [self configTableView];
}

- (void)configNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"保存") style:UIBarButtonItemStylePlain target:self action:@selector(checkTeacherInfo)];
}

- (void)configTableView
{
    _lblDescName.textColor       = [UIColor cm_blackColor_333333_1];
    _lblDescSex.textColor        = [UIColor cm_blackColor_333333_1];
    _lblDescAge.textColor        = [UIColor cm_blackColor_333333_1];
    _lblDescAccount.textColor    = [UIColor cm_blackColor_333333_1];
    _lblDescPassword.textColor   = [UIColor cm_blackColor_333333_1];
    _lblDescRePassword.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescRemark.textColor     = [UIColor cm_blackColor_333333_1];
    _lblMaxRemarkLength.textColor   = [UIColor cm_blackColor_666666_1];
    _lblRemarkPlaceholder.textColor = [UIColor cm_placeholderColor_C7C7CD_1];
    
    _lblDescName.font        = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescSex.font         = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescAge.font         = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescAccount.font     = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescPassword.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescRePassword.font  = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescRemark.font      = [UIFont systemFontOfSize:cFontSize_16];
    _lblMaxRemarkLength.font   = [UIFont systemFontOfSize:cFontSize_14];
    _lblRemarkPlaceholder.font = [UIFont systemFontOfSize:cFontSize_14];
    
    _txtfName.textColor       = [UIColor cm_blackColor_333333_1];
    _txtfAge.textColor        = [UIColor cm_blackColor_333333_1];
    _txtfAccount.textColor    = _isEdit ? [UIColor cm_grayColor__807F7F_1] : [UIColor cm_blackColor_333333_1];
    _txtfAreacode.textColor   = [UIColor cm_blackColor_333333_1];
    _txtfPassword.textColor   = [UIColor cm_blackColor_333333_1];
    _txtfRePassword.textColor = [UIColor cm_blackColor_333333_1];
    _txtRemark.textColor      = [UIColor cm_blackColor_333333_1];
    
    _txtfName.font       = [UIFont systemFontOfSize:cFontSize_16];
    _txtfAge.font        = [UIFont systemFontOfSize:cFontSize_16];
    _txtfAccount.font    = [UIFont systemFontOfSize:cFontSize_16];
    _txtfAreacode.font   = [UIFont systemFontOfSize:cFontSize_16];
    _txtfPassword.font   = [UIFont systemFontOfSize:cFontSize_16];
    _txtfRePassword.font = [UIFont systemFontOfSize:cFontSize_16];
    _txtRemark.font      = [UIFont systemFontOfSize:cFontSize_14];
    
    _imgSex.image = [UIImage imageNamed:@"icon_arrow_right"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row) {
        [self configPickViewSex];
    }
}

#pragma mark - 保存教师信息
/** 检查教师信息 */
- (void)checkTeacherInfo
{
    // 检查是否包含 emoji
    if ([NSString stringContainsEmoji:_txtfName.text] ||
        [NSString stringContainsEmoji:_txtfAge.text] ||
        [NSString stringContainsEmoji:_txtfAccount.text] ||
        [NSString stringContainsEmoji:_txtfPassword.text] ||
        [NSString stringContainsEmoji:_txtfRePassword.text] ||
        [NSString stringContainsEmoji:_txtRemark.text]) {
        [self presentFailureTips:LOCALIZATION(@"不能输入emoji表情")];
        return;
    }
    // 检查特殊字符
    if ([NSString stringContainsIllegalCharacter:_txtfName.text]) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@", LOCALIZATION(@"姓名"), LOCALIZATION(@"不能输入特殊符号")]];
        return;
    }
    if ([NSString stringContainsIllegalCharacter:_txtfAge.text]) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@", LOCALIZATION(@"年龄"), LOCALIZATION(@"不能输入特殊符号")]];
        return;
    }
    // 检查字符超限
    if (_txtfName.text.charLength > cMaxNameLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"申请人姓名"),LOCALIZATION(@"字符长度为"), cMaxNameLength]];
        return;
    }
    if (_txtRemark.text.charLength > cMaxClassDescLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"备注"),LOCALIZATION(@"字符长度为"), cMaxClassDescLength]];
        return;
    }
    // 密码检查
    // 创建教师 必须有密码
    if (!_isEdit && [_txtfPassword.text notPassword]) {
        [self presentFailureTips:LOCALIZATION(@"密码为8-16个字符，由英文、数字组成")];
        return;
    }
    // 如果输入了密码则必须是密码格式
    if (_txtfPassword.text.length > 0 && [_txtfPassword.text notPassword]) {
        [self presentFailureTips:LOCALIZATION(@"密码为8-16个字符，由英文、数字组成")];
        return;
    }
    if (![_txtfPassword.text isEqualToString:_txtfRePassword.text]) {
        [self presentFailureTips:LOCALIZATION(@"两次输入的密码不一样，请确认后重新输入")];
        return;
    }
    
    // 姓名检查
    if ([NSString isEmpty:_txtfName.text]) {
        [self presentFailureTips:LOCALIZATION(@"姓名不能为空")];
        return;
    }
    // 年龄检查
    if (![_txtfAge.text isNumber]) {
        [self presentFailureTips:LOCALIZATION(@"年龄请输入数字")];
        return;
    }
    // 创建教师
    if (!_isEdit) {
        if ([NSString isEmpty:_txtfAreacode.text]) {
            [self presentFailureTips:LOCALIZATION(@"国家码不能为空")];
            return;
        }
        
        if ([NSString isEmpty:_txtfAccount.text]) {
            [self presentFailureTips:LOCALIZATION(@"账号不能为空")];
            return;
        }
        else {
            if (![_txtfAccount.text isEmail] && ![_txtfAccount.text isNumber]) {
                [self presentFailureTips:LOCALIZATION(@"请输入正确格式的手机号或邮箱")];
                return;
            }
        }
        [self showWaitTips];
        // 如果账号是邮箱类型,则发送邮箱验证码
        if ([_txtfAccount.text isEmail]) {
            _accountType = ENUM_AccountTypeEmail;
            [self organizationVerifySingleWithEmail];
        }
        // 如果账号是数字,则发送手机验证码
        else if ([_txtfAccount.text isNumber]) {
            _accountType = ENUM_AccountTypePhone;
            [self organizationVerifySingleWithPhone];
        }
    }
    else {
        [self showWaitTips];
        [self editTeacherInfo];
    }
}

/** 用户验证手机的唯一性 */
- (void)organizationVerifySingleWithPhone
{
    WeakSelf(self)
    NSString *account  = _txtfAccount.text;
    NSString *userType = [NSString stringWithFormat:@"%ld", ENUM_AccountTypePhone];
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:account userType:userType completion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
        else
            [weakself saveTeacherInfo];
    }];
}

/** 用户验证邮箱的唯一性 */
- (void)organizationVerifySingleWithEmail
{
    WeakSelf(self)
    NSString *account  = _txtfAccount.text;
    NSString *userType = [NSString stringWithFormat:@"%ld", ENUM_AccountTypeEmail];
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:account userType:userType completion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
        else
            [weakself saveTeacherInfo];
    }];
}

/** 保存用户信息 */
- (void)saveTeacherInfo
{
    WeakSelf(self)
    NSString *phone = _isEdit ? _teacher.phone : (_accountType == ENUM_AccountTypePhone ? _txtfAccount.text : @"");
    NSString *email = _isEdit ? _teacher.email : (_accountType == ENUM_AccountTypeEmail ? _txtfAccount.text : @"");
    NSString *areacode = _isEdit ? [NSString stringWithFormat:@"%ld", _teacher.areacode] : _txtfAreacode.text;
    [[ClassRequest sharedInstance] addTeacherInfoWithPhone:phone email:email password:_txtfPassword.text areacode:areacode name:_txtfName.text sex:_sex age:_txtfAge.text remark:_txtRemark.text completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            // 获取教师列表
            self.arrTeachers = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_TeacherList];
            NSArray *teacherIds = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
            UserModel *teacher = [UserModel new];
            teacher.userId = [[teacherIds firstObject][@"teacherId"] integerValue];
            teacher.email = self.accountType == ENUM_AccountTypeEmail ? self.txtfAccount.text : @"";
            teacher.phone = self.accountType == ENUM_AccountTypePhone ? self.txtfAccount.text : @"";
            teacher.areacode = [self.txtfAreacode.text integerValue];
            teacher.organizationId = [UserRequest sharedInstance].user.userId;
            teacher.name = self.txtfName.text;
            teacher.sex = self.sex;
            teacher.age = [self.txtfAge.text integerValue];
            teacher.remark = self.txtRemark.text;
            // 加入教师列表
            [self.arrTeachers addObject:teacher];
            // 保存教师信息
            [[CacheDataSource sharedInstance] setCache:self.arrTeachers withCacheKey:CacheKey_TeacherList];
            self.addTeacherSuccess();
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/** 修改教师信息 */
- (void)editTeacherInfo
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] updateTeacherWithType:ENUM_UpdateTypeUp teacherId:_teacher.userId password:_txtfPassword.text name:_txtfName.text sex:_sex age:_txtfAge.text.integerValue remark:_txtRemark.text
     completion:^(id object, ErrorModel *error) {
         StrongSelf(self)
         [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.teacher.name = self.txtfName.text;
            self.teacher.sex = self.sex;
            self.teacher.age = [self.txtfAge.text integerValue];
            self.teacher.remark = self.txtRemark.text;
            self.updateTeacherSuccess(self.teacher);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/** 性别选择 */
- (void)configPickViewSex
{
    [self.view endEditing:YES];
    if (_pickViewSex == nil) {
        _pickViewSex = [[ZPickView alloc] initWithFrame:self.view.bounds dataSource:self.arrSex selected:0];
        _pickViewSex.delegates = self;
        [self.view addSubview:_pickViewSex];
    }
    [_pickViewSex show];
}

/** 选择国家 */
- (void)toSelectCountry
{
    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = [UserRequest sharedInstance].language;
    WeakSelf(self)
    addressVC.selectedCountryBlock = ^(CountryModel * country) {
        weakself.txtfAreacode.text = country.areacode;
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark - textfield delegate

- (void)textFieldDidChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if ([_txtfAge isEqual:textField]) {
        if (_txtfAge.text.length > 3)
            _txtfAge.text = [_txtfAge.text substringToIndex:3];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_txtfAreacode]) {
        [self toSelectCountry];
        return NO;
    }
    else if ([textField isEqual:_txtfAccount]) {
        return !_isEdit;
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    _lblRemarkPlaceholder.hidden = textView.text.length > 0;
    _lblMaxRemarkLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtRemark.text.charLength, cMaxClassDescLength];
}

#pragma mark - ZPickViewDelegate

- (void)ZPickerViewCancel:(ZPickView *)picker
{
    [picker hidden];
}

- (void)ZPickerView:(ZPickView *)picker makeSureIndex:(NSInteger)index
{
    _lblSex.text = _arrSex[index];
    _sex = index;
    [picker hidden];
}

#pragma mark - 属性

- (NSArray *)arrSex
{
    if (_arrSex == nil) {
        _arrSex = @[LOCALIZATION(@"男"), LOCALIZATION(@"女")];
    }
    return _arrSex;
}

@end
