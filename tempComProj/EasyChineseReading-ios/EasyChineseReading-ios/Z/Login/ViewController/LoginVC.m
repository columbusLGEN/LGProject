//
//  LoginVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LoginVC.h"

#import "WXApi.h"

#import "LTextFieldTableViewCell.h"
#import "LButtonTableViewCell.h"
#import "LFooterView.h"

#import "RegisterVC.h"              // 注册
#import "ForgotPasswordManageVC.h"  // 找回密码
#import "RegisterWeChatUserVC.h"
#import "RegisterAgreementVC.h"

static CGFloat const kFooterHeight = 150.f; // tableViewFooter 的高度

#define kTextFieldCell NSStringFromClass([LTextFieldTableViewCell class])
#define kButtonCell    NSStringFromClass([LButtonTableViewCell class])

@interface LoginVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LFooterViewDelegate, LButtonTableViewCellDelegate, WXApiDelegate>

@property (strong, nonatomic) UITableView *tableView;
/** 界面配置 */
@property (strong, nonatomic) NSArray *arrViewConfiguration;
/** 键盘高度 */
@property (assign, nonatomic) CGFloat keyBoardHeight;
/** table 偏移量 */
@property (assign, nonatomic) CGFloat tableOffset;
/** 选中的cell */
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
/** 用户名 */
@property (strong, nonatomic) NSString *user;
/** 密码 */
@property (strong, nonatomic) NSString *password;
/** 登录类型(0 普通用户 1 机构用户) */
@property (assign, nonatomic) NSInteger loginType;
/** 选择注册类型 */
@property (strong, nonatomic) ZSegment *segment;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configHeaderView];
    [self configTableView];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 配置登录界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"用户登录");
}

- (void)configHeaderView
{
    _loginType = ENUM_UserTypePerson;
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"个人用户") rightTitle:LOCALIZATION(@"机构用户")];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        [weakself updateLoginTypeWithType:ENUM_UserTypePerson];
    };
    _segment.selectedRight = ^{
        [weakself updateLoginTypeWithType:ENUM_UserTypeOrganization];
    };
}

/** 修改登录类型 */
- (void)updateLoginTypeWithType:(NSInteger)type
{
    _loginType = type;
    [_tableView reloadData];
}

#pragma mark - 配置界面
- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.sectionFooterHeight = kFooterHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:kTextFieldCell bundle:nil] forCellReuseIdentifier:kTextFieldCell];
    [_tableView registerNib:[UINib nibWithNibName:kButtonCell    bundle:nil] forCellReuseIdentifier:kButtonCell];
}

- (void)addNotification
{
    // 监听 键盘出现或改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 监听 键盘退出。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationAlertError usingBlock:^(NSNotification *note) {
        [weakself presentFailureTips:note.object];
    }];
    
    [self fk_observeNotifcation:kNotificationWXAccessToken usingBlock:^(NSNotification *note) {
        NSString *code = note.object;
        [weakself getAccessTokenWithCode:code];
    }];
}

- (void)baseViewControllerDismiss
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    if ([cell.reuseIdentifier isEqualToString:kButtonCell]) {
        LButtonTableViewCell *bCell = (LButtonTableViewCell *)cell;
        bCell.delegate = self;
    }
    [self configTextWithCell:cell];
    return cell;
}

#pragma mark - action

- (void)configTextWithCell:(UITableViewCell *)cell
{
    LTextFieldTableViewCell *tCell = (LTextFieldTableViewCell *)cell;
    if ([cell.reuseIdentifier isEqualToString:kTextFieldCell])
        [tCell.txtfContent addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 100: _user = textField.text;     break;
        case 101: _password = textField.text; break;
        default: break;
    }
    
    LButtonTableViewCell *cell = (LButtonTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if ([cell isKindOfClass:[LButtonTableViewCell class]])
        [cell updateButtonEnable:_user.length > 0 && _password.length > 0];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LFooterView *footerView = [LFooterView loadFromNib];
    footerView.delegate = self;
    footerView.loginType = _loginType;
    return footerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - LFooterViewDelegate

/** 注册 */
- (void)registerNow
{
    RegisterAgreementVC *RAVC = [RegisterAgreementVC new];
    RAVC.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:RAVC animated:YES];
}

/** 忘记密码 */
- (void)forgetPassword
{
    ForgotPasswordManageVC *forgotPassword = [ForgotPasswordManageVC new];
    [self.navigationController pushViewController:forgotPassword animated:YES];
}

/** 第三方登录 */
- (void)loginByIndex:(NSInteger)index
{
    // 0 微信登录 1 北语登录
    if (0 == index)
        [self clickWeChatToLogin];
    else if (1 == index)
        [self loginWithBeiyu];
}

#pragma mark 微信登录

/** 点击微信登录 */
- (void)clickWeChatToLogin
{
    // 判断机器上是否有微信
    if ([WXApi isWXAppInstalled])
        [[WXLogin sharedInstance] getCode];
}

/** 刷新或续期 accessToken */
- (void)weChatRefreshAccessToken
{
    [self showWaitTips];
    WeakSelf(self)
    [[WXLogin sharedInstance] refreshAccessTokenComplete:^(id object, NSError *error) {
        StrongSelf(self)
        if (error) {
            [self dismissTips];
            if (error.code == -1)
                [self getAccessTokenWithCode:[[NSUserDefaults standardUserDefaults] objectForKey:WX_CODE]];
            else
                [self presentFailureTips:error.domain];
        }
        else {
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:object];
            NSString *accessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (accessToken) {
                [self getUserInfoWithWXInfo];
            }
            else {
                [self dismissTips];
                [[WXLogin sharedInstance] getCode];
            }
        }
    }];
}

/** 通过 code 获取 accessToken */
- (void)getAccessTokenWithCode:(NSString *)code
{
    [self showWaitTips];
    WeakSelf(self)
    [[WXLogin sharedInstance] getAccessTokenWithCode:code complete:^(id object, NSError *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error)
            [self fk_postNotification:kNotificationAlertError object:error.domain];
        else
            [self weChatRefreshAccessToken];
    }];
}

/** 获取个人用户信息 */
- (void)getUserInfoWithWXInfo
{
    WeakSelf(self)
    [[WXLogin sharedInstance] getUserInfoComplete:^(id object, NSError *error) {
        StrongSelf(self)
        if (error) {
            [self dismissTips];
            [self fk_postNotification:kNotificationAlertError object:error.domain];
        }
        else {
            NSDictionary *dic = object;
            [self loginWithWeChatWithInfo:dic];
        }
    }];
}

/** 通过获取到的 unionid 登录账号 */
- (void)loginWithWeChatWithInfo:(NSDictionary *)info
{
    NSString *unionid = info[@"unionid"];
    WeakSelf(self)
    [[UserRequest sharedInstance] loginWithWeChatUnionid:unionid completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            if (error.code == 205) { // 未注册 提交注册申请
                RegisterWeChatUserVC *registerWX = [RegisterWeChatUserVC new];
                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:info];
                NSNumber *sexNum = info[@"sex"];
                NSString *strSex = [NSString stringWithFormat:@"%ld", sexNum.integerValue - 1];
                muDic[@"sex"] = strSex;
                registerWX.userDic = muDic;
                [self.navigationController pushViewController:registerWX animated:YES];
            }
            else {
                [self presentFailureTips:error.message];
            }
        }
        else {
            UserModel *user = [UserModel mj_objectWithKeyValues:object[@"user"]];
            [UserRequest sharedInstance].user = user;
            [UserRequest sharedInstance].token = object[@"token"];
            [[UserRequest sharedInstance] saveCache];
            [self fk_postNotification:kNotificationUserLogin];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark 北语登录

// 北语登录
- (void)loginWithBeiyu
{
    // TODO: 北语登录
}

#pragma mark - LButtonTableViewCellDelegate
#pragma mark 登录
/** 登录 */
- (void)login
{
    NSString *userType = @""; // 用户类型
    
    if ([NSString isEmpty:_user]) {
        [self presentFailureTips:LOCALIZATION(@"账号不能为空")];
        return;
    }
    
    if ([_user isEmail]) {
        userType = [NSString stringWithFormat:@"%lu", (unsigned long)ENUM_AccountTypeEmail];
    }
    else if ([_user isNumber]) {
        userType = [NSString stringWithFormat:@"%lu", (unsigned long)ENUM_AccountTypePhone];
    }
    else {
        [self presentFailureTips:LOCALIZATION(@"账号类型错误，账号为手机/邮箱号")];
        return;
    }
    
    if ([_password notPassword]) {
        [self presentFailureTips:LOCALIZATION(@"密码为8-16个字符，由英文、数字组成")];
        return;
    }
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] loginWithType:[NSString stringWithFormat:@"%ld", ENUM_LoginTypePassword]
                                       userType:userType
                                           user:_user
                                       password:_password
                                         userId:@""
                                          token:@""
                                    accountType:[NSString stringWithFormat:@"%@", _loginType == ENUM_UserTypeOrganization ? @"1" : @"0"]
                                     completion:^(id object, ErrorModel *error) {
                                         StrongSelf(self)
                                         [self dismissTips];
                                         if (error)
                                             [self presentFailureTips:error.message];
                                         else
                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                     }];
}

#pragma mark - 键盘监听

// 键盘出现或改变
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    if (cell.y + cell.height > self.view.height - _keyBoardHeight) {
        _tableOffset = (cell.y + cell.height) - self.view.height + _keyBoardHeight;
        _tableView.frame = CGRectMake(0, -_tableOffset, Screen_Width, self.view.height);
    }
}

// 键盘退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    _tableView.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_64 - 2*cHeaderHeight_44);
}

#pragma mark - 界面配置

- (NSArray *)arrViewConfiguration
{
    if (_arrViewConfiguration == nil) {
        _arrViewConfiguration = @[@{@"index": @"100", @"identify": kTextFieldCell, @"placeHolder": LOCALIZATION(@"邮箱/手机号"), @"icon": @"icon_login_user_account"},
                                  @{@"index": @"101", @"identify": kTextFieldCell, @"placeHolder": LOCALIZATION(@"输入密码"), @"icon": @"icon_login_password", @"password": @"1"},
                                  @{@"index": @"103", @"identify": kButtonCell, @"remember": @(1)}];
    }
    return _arrViewConfiguration;
}

@end
