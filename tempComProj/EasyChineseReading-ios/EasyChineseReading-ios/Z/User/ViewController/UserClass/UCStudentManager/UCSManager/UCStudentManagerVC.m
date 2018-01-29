//
//  UCSManagerAddVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCStudentManagerVC.h"
#import "UserInfoAddressVC.h"

@interface UCStudentManagerVC () <UITextFieldDelegate, ZPickViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDescClass;
@property (weak, nonatomic) IBOutlet UILabel *lblDescName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescSex;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAge;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblDescPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblDescRePassword;
@property (weak, nonatomic) IBOutlet UILabel *lblDescRemark;
@property (weak, nonatomic) IBOutlet UILabel *lblRemarkPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxRemarkLength;

@property (weak, nonatomic) IBOutlet UILabel *lblClass;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;

@property (weak, nonatomic) IBOutlet UIImageView *imgSex;
@property (weak, nonatomic) IBOutlet UIImageView *imgClass;

@property (weak, nonatomic) IBOutlet UITextField *txtfName;
@property (weak, nonatomic) IBOutlet UITextField *txtfAge;
@property (weak, nonatomic) IBOutlet UITextField *txtfAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtfAreacode;
@property (weak, nonatomic) IBOutlet UITextField *txtfPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtfRePassword;

@property (weak, nonatomic) IBOutlet UITextView *txtRemark;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightClassConstraint;

@property (strong, nonatomic) ZPickView *pickViewSex;   // 性别
@property (strong, nonatomic) ZPickView *pickViewClass; // 班级

@property (strong, nonatomic) NSArray *arrSex;   // 性别
@property (strong, nonatomic) NSArray *arrClass; // 班级

@property (assign, nonatomic) NSInteger sex; // 性别
@property (assign, nonatomic) NSInteger classIndex; // 班级
@property (assign, nonatomic) NSInteger accountType; // 账号类型

@property (assign, nonatomic) ClassModel *classInfo;

@end

@implementation UCStudentManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    if (_isEdit) {
        [self configDate];
    }
    _classInfo = self.arrClass.firstObject;
    _lblClass.text = _student.classId ? _student.className : _classInfo.className;
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
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        if (self.arrClass.count > 0)
            [self configPickViewClass];
        else
            [self presentFailureTips:LOCALIZATION(@"还没有班级啊")];
    }
    else if (2 == indexPath.row) {
        [self configPickViewSex];
    }
}

#pragma mark - action

- (void)updateSystemLanguage
{
    self.title = _isEdit ? LOCALIZATION(@"修改学生") : LOCALIZATION(@"创建学生");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"保存") style:UIBarButtonItemStylePlain target:self action:@selector(checkStudentInfo)];
    
    _lblDescClass.text      = LOCALIZATION(@"所属班级");
    _lblDescName.text       = LOCALIZATION(@"姓名");
    _lblDescSex.text        = LOCALIZATION(@"性别");
    _lblDescAge.text        = LOCALIZATION(@"年龄");
    _lblDescAccount.text    = LOCALIZATION(@"账号");
    _lblDescRemark.text     = LOCALIZATION(@"备注");
    _lblDescPassword.text   = LOCALIZATION(@"密码");
    _lblDescRePassword.text = LOCALIZATION(@"确认密码");
    _lblSex.text            = LOCALIZATION(@"男");
    _lblRemarkPlaceholder.text = [NSString stringWithFormat:@"%@ %ld", LOCALIZATION(@"字符长度为"), cMaxClassDescLength];

    _txtfName.placeholder       = LOCALIZATION(@"请输入学生姓名");
    _txtfAge.placeholder        = LOCALIZATION(@"请输入学生年龄");
    _txtfAccount.placeholder    = LOCALIZATION(@"请输入邮箱/手机号作为账号");
    _txtfAreacode.placeholder   = _isEdit ? @"" : LOCALIZATION(@"国家码");
    _txtfPassword.placeholder   = [NSString stringWithFormat:@"%@", LOCALIZATION(@"输入密码")];
    _txtfRePassword.placeholder = LOCALIZATION(@"再次输入密码");
}

- (void)configTableView
{
    _lblDescName.textColor       = [UIColor cm_blackColor_333333_1];
    _lblDescSex.textColor        = [UIColor cm_blackColor_333333_1];
    _lblDescAge.textColor        = [UIColor cm_blackColor_333333_1];
    _lblDescPassword.textColor   = [UIColor cm_blackColor_333333_1];
    _lblDescRePassword.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescRemark.textColor     = [UIColor cm_blackColor_333333_1];
    _lblDescAccount.textColor    = [UIColor cm_blackColor_333333_1];
    _lblRemarkPlaceholder.textColor = [UIColor cm_placeholderColor_C7C7CD_1];
    _lblMaxRemarkLength.textColor = [UIColor cm_blackColor_666666_1];

    _lblDescName.font        = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescSex.font         = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescAge.font         = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescAccount.font     = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescPassword.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescRePassword.font  = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescRemark.font      = [UIFont systemFontOfSize:cFontSize_16];
    _lblRemarkPlaceholder.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblMaxRemarkLength.font = [UIFont systemFontOfSize:cFontSize_14];

    _txtfName.textColor       = [UIColor cm_blackColor_333333_1];
    _txtfAge.textColor        = [UIColor cm_blackColor_333333_1];
    _txtfAreacode.textColor   = [UIColor cm_blackColor_333333_1];
    _txtfAccount.textColor    = _isEdit ? [UIColor cm_grayColor__807F7F_1] : [UIColor cm_blackColor_333333_1];
    _txtfPassword.textColor   = [UIColor cm_blackColor_333333_1];
    _txtfRePassword.textColor = [UIColor cm_blackColor_333333_1];
    _txtRemark.textColor      = [UIColor cm_blackColor_333333_1];
    
    _imgClass.image = _imgSex.image = [UIImage imageNamed:@"icon_arrow_right"];
}

- (void)configDate
{
    _txtfName.text    = _student.name;
    _lblSex.text      = [NSString stringWithFormat:@"%@", _student.sex == ENUM_SexTypeMan ? LOCALIZATION(@"男") : LOCALIZATION(@"女")];
    _txtfAge.text     = [NSString stringWithFormat:@"%ld", _student.age];
    _txtfAccount.text = _student.phone.length > 0 ? [NSString stringWithFormat:@"+%ld %@", _student.areacode, _student.phone] : _student.email;
    _txtRemark.text   = _student.remark;
    _lblRemarkPlaceholder.hidden = _txtRemark.text.length > 0;
}

#pragma mark - 保存学生信息

- (void)checkStudentInfo
{
    // 手机号检查
    if ([NSString isEmpty:_txtfName.text]) {
        [self presentFailureTips:LOCALIZATION(@"姓名不能为空")];
        return;
    }

    if ([NSString isEmpty:_txtfAccount.text]) {
        [self presentFailureTips:LOCALIZATION(@"账号不能为空")];
        return;
    }
    
    // 检查 emoji
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
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"姓名"),LOCALIZATION(@"字符长度为"), cMaxNameLength]];
        return;
    }
    if (_txtRemark.text.charLength > cMaxClassDescLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"备注"),LOCALIZATION(@"字符长度为"), cMaxClassDescLength]];
        return;
    }
    
    // 密码检查
    // 创建学生 必须有密码
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
    
    if (!_isEdit) {
        if (![_txtfAccount.text isEmail] && ![_txtfAccount.text isNumber]) {
            [self presentFailureTips:LOCALIZATION(@"请输入正确格式的手机号或邮箱")];
            return;
        }
        if ([NSString isEmpty:_txtfAreacode.text]) {
            [self presentFailureTips:LOCALIZATION(@"国家码不能为空")];
            return;
        }
        if ((_classIndex == 0 && [_lblClass.text empty]) || !_classInfo) {
            [self presentFailureTips:LOCALIZATION(@"还没有班级啊")];
            return;
        }
        
        if (![_txtfAge.text isNumber]) {
            [self presentFailureTips:LOCALIZATION(@"年龄请输入数字")];
            return;
        }
        
        [self showWaitTips];
        if ([_txtfAccount.text isEmail]) {
            _accountType = ENUM_AccountTypeEmail;
            [self organizationVerifySingleWithEmail];
        }
        else if ([_txtfAccount.text isNumber]) {
            _accountType = ENUM_AccountTypePhone;
            [self organizationVerifySingleWithPhone];
        }
        else {
            [self presentFailureTips:LOCALIZATION(@"账号类型错误，账号为手机/邮箱号")];
            return;
        }
    }
    else {
        [self editStudentInfo];
    }
}

/** 用户验证手机的唯一性 */
- (void)organizationVerifySingleWithPhone
{
    WeakSelf(self)
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:_txtfAccount.text
                                                         userType:[NSString stringWithFormat:@"%ld", ENUM_AccountTypePhone]
                                                       completion:^(id object, ErrorModel *error) {
                                                           if (error)
                                                               [weakself presentFailureTips:error.message];
                                                           else
                                                               [weakself addStudentInfo];
                                                       }];
}

/** 用户验证邮箱的唯一性 */
- (void)organizationVerifySingleWithEmail
{
    WeakSelf(self)
    [[UserRequest sharedInstance] verifyAccountSingleWithUserName:_txtfAccount.text
                                                         userType:[NSString stringWithFormat:@"%ld", ENUM_AccountTypeEmail]
                                                       completion:^(id object, ErrorModel *error) {
                                                           if (error)
                                                               [weakself presentFailureTips:error.message];
                                                           else
                                                               [weakself addStudentInfo];
                                                       }];
}

/** 创建学生 */
- (void)addStudentInfo
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] addStudentInfoWithClassId:_classInfo.classId
                                                        name:_txtfName.text
                                                         age:[_txtfAge.text integerValue]
                                                       Phone:_accountType == ENUM_AccountTypePhone ? _txtfAccount.text : @""
                                                    areacode:_txtfAreacode.text
                                                       email:_accountType == ENUM_AccountTypeEmail ? _txtfAccount.text : @""
                                                    password:_txtfPassword.text
                                                         sex:_sex
                                                      remark:_txtRemark.text
                                                  completion:^(id object, ErrorModel *error) {
                                                      StrongSelf(self)
                                                      [self dismissTips];
                                                      if (error) {
                                                          [self presentFailureTips:error.message];
                                                      }
                                                      else {
                                                          UserModel *user = [UserModel new];
                                                          
                                                          user.name = self.txtfName.text;
                                                          user.age = [self.txtfAge.text integerValue];
                                                          user.sex = self.sex;
                                                          user.email = self.accountType == ENUM_AccountTypeEmail ? self.txtfAccount.text : @"";
                                                          user.phone = self.accountType == ENUM_AccountTypePhone ? self.txtfAccount.text : @"";
                                                          user.classId = self.classInfo.classId;
                                                          user.className = self.classInfo.className;
                                                          user.remark = self.txtRemark.text;
                                                          
                                                          NSArray *classIds = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
                                                          user.userId = [[classIds firstObject][@"userId"] integerValue];
                                                          
                                                          [self fk_postNotification:kNotificationCreateStudentInfo object:user];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }
                                                  }];
}

/** 保存学生信息 */
- (void)editStudentInfo
{
    if (!_classInfo) {
        [self presentFailureTips:LOCALIZATION(@"还没有班级啊")];
        return;
    }
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] updateStudentInfoWithClassId:_classInfo.classId > 0 ? _classInfo.classId : _student.classId
                                                         userId:_student.userId
                                                           name:_txtfName.text
                                                            age:[_txtfAge.text integerValue]
                                                       password:_txtfPassword.text
                                                            sex:_sex
                                                         remark:_txtRemark.text
                                                     completion:^(id object, ErrorModel *error) {
                                                         StrongSelf(self)
                                                         [self dismissTips];
                                                         if (error) {
                                                             [self presentFailureTips:error.message];
                                                         }
                                                         else {
                                                             self.student.classId   = self.classInfo.classId > 0 ? self.classInfo.classId : self.student.classId;
                                                             self.student.className = self.classInfo.classId > 0 ? self.classInfo.className : self.student.className;
                                                             self.student.name      = self.txtfName.text;
                                                             self.student.age       = [self.txtfAge.text integerValue];
                                                             self.student.sex       = self.sex;
                                                             self.student.remark    = self.txtRemark.text;
                                                             self.updateTStudentSuccess(self.student);
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }
                                                     }];
}

/** 性别选择 */
- (void)configPickViewSex
{
    if (_pickViewSex == nil) {
        _pickViewSex = [[ZPickView alloc] initWithFrame:self.view.bounds dataSource:self.arrSex selected:0];
        _pickViewSex.delegates = self;
        [self.view addSubview:_pickViewSex];
    }
    [self resignAllFirstResponder];
    [_pickViewSex show];
}

/** 班级选择 */
- (void)configPickViewClass
{
    if (_pickViewClass == nil) {
        _pickViewClass = [[ZPickView alloc] initWithFrame:self.view.bounds dataSource:self.arrClass selected:0];
        _pickViewClass.delegates = self;
        [self.view addSubview:_pickViewClass];
    }
    [self resignAllFirstResponder];
    [_pickViewClass show];
}

#pragma mark - ZPickViewDelegate

- (void)ZPickerViewCancel:(ZPickView *)picker
{
    [picker hidden];
}

- (void)ZPickerView:(ZPickView *)picker makeSureIndex:(NSInteger)index
{
    if ([picker isEqual:_pickViewSex]) {
        _sex = index;
        _lblSex.text = _arrSex[index];
    }
    else {
        _classIndex = index;
        _classInfo = index > 0 ? _arrClass[index] : _arrClass.firstObject;
        _lblClass.text = _classInfo.className;
    }
    [picker hidden];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if ([_txtfAge isEqual:textField]) {
        if (_txtfAge.text.length > 3) {
            _txtfAge.text = [_txtfAge.text substringToIndex:3];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_pickViewSex.showing) {
        [_pickViewSex hidden];
    }
    if (_pickViewClass.showing) {
        [_pickViewClass hidden];
    }
    return YES;
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

/** 选择国家 */
- (void)toSelectCountry
{
    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = [UserRequest sharedInstance].language;
    addressVC.selectedCountryBlock = ^(CountryModel * country){
        _txtfAreacode.text = country.areacode;
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark -

- (void)textViewDidChange:(UITextView *)textView
{
    _lblRemarkPlaceholder.hidden = textView.text.length > 0;
    _lblMaxRemarkLength.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.charLength, cMaxClassDescLength];
}

#pragma mark - 取消第一响应者

- (void)resignAllFirstResponder
{
    [self.view endEditing:YES];
}

#pragma mark - 属性

- (NSArray *)arrClass
{
    if (_arrClass == nil) {
        _arrClass = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
    }
    return _arrClass;
}

- (NSArray *)arrSex
{
    if (_arrSex == nil) {
        _arrSex = @[LOCALIZATION(@"男") , LOCALIZATION(@"女")];
    }
    return _arrSex;
}


@end
