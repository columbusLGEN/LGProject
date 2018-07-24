//
//  UCLoginViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCLoginViewController.h"
#import "UCAccountHitViewController.h"
#import "DJUser.h"
#import "LIGMainTabBarController.h"

static NSString * const dj_username_local = @"dj_username";

@interface UCLoginViewController ()<
UCAccountHitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (assign,nonatomic) BOOL pwdIsSecureEntry;
@property (weak, nonatomic) IBOutlet UIButton *eye;


@end

@implementation UCLoginViewController

+ (UINavigationController *)navWithLoginvc{
    UCLoginViewController *loginvc = (UCLoginViewController *)[[UIStoryboard storyboardWithName:UserCenterStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:@"UCLoginViewController"];
    loginvc.canBack = NO;
    return [[LGBaseNavigationController alloc] initWithRootViewController:loginvc];
}

- (void)setNavLeftBackItem{
    if (_canBack) {
        [super setNavLeftBackItem];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户登录";
    
    _pwdIsSecureEntry = _pwd.isSecureTextEntry;
    _eye.selected = _pwdIsSecureEntry;
    
    _username.text = [[NSUserDefaults standardUserDefaults] objectForKey:dj_username_local];
}

- (IBAction)displayPwd:(UIButton *)sender {
    if (_pwdIsSecureEntry) {
        _pwd.secureTextEntry = NO;
    }else{
        _pwd.secureTextEntry = YES;
    }
    _pwdIsSecureEntry = _pwd.isSecureTextEntry;
    sender.selected = _pwdIsSecureEntry;
}
- (IBAction)forgetPwd:(id)sender {
    /// 忘记密码
    [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"EDJModifiPwdViewController" animated:YES];
}

- (IBAction)login:(id)sender {
    [[DJUser new] keepUserInfo];

    /// 登录
    if (_username.text == nil || [_username.text isEqualToString:@""]) {
        [self.view presentFailureTips:@"请输入手机号"];
    }else if (![_username.text isPhone]) {
        [self.view presentFailureTips:@"请输入正确的手机号"];
    }else if (_pwd.text == nil || [_pwd.text isEqualToString:@""]) {
        [self.view presentFailureTips:@"请输入密码"];
    }else{
//        [self ucanLoginWithTel:_username.text pwd:_pwd.text];
        [self userLoginWithTel:_username.text pwd:_pwd.text];
    }
}
/// 账号激活
- (IBAction)acountHit:(UIButton *)sender {
    UCAccountHitViewController *hvc = (UCAccountHitViewController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCAccountHitViewController"];
    hvc.delegate = self;
    
    [self.navigationController pushViewController:hvc animated:YES];
}

- (void)userLoginWithTel:(NSString *)tel pwd:(NSString *)pwd{
    [[LGLoadingAssit sharedInstance] homeAddLoadingViewTo:self.view];
    /// TODO: 计算 密码 MD5
    NSString *pwd_md5 = pwd;
    [[DJUserNetworkManager sharedInstance] userLoginWithTel:tel pwd_md5:pwd_md5 success:^(id responseObj) {
        NSLog(@"userlogin: %@",responseObj);
        /**
         服务端应返回的情况
         1.登录失败
         账号未激活
         密码错误
         
         2.登录成功
         返回用户信息
         */
        
        /// 登录成功之后，记录用户名，下次自动填充
        [[NSUserDefaults standardUserDefaults] setValue:tel forKey:dj_username_local];
        
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        DJUser *user = [DJUser mj_objectWithKeyValues:responseObj];
        
        /// 用户信息本地化
        [user keepUserInfo];
        
        /// 将本地用户信息赋值给单利对象,保证每次用户重新登录之后，都会重新赋值
        [[DJUser sharedInstance] getLocalUserInfo];
        
        if (!_canBack) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [LIGMainTabBarController new];
        }
        
    } failure:^(id failureObj) {
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        if ([failureObj isKindOfClass:[NSError class]]) {
            NSLog(@"failure_error: %@",failureObj);
        }
        if ([failureObj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"failure_dict: %@",failureObj);
            NSString *msg = failureObj[@"msg"];
            [self.view presentFailureTips:msg];
        }
    }];
}

#pragma mark - UCAccountHitViewController
- (void)ucanLoginWithTel:(NSString *)tel pwd:(NSString *)pwd{
    _username.text = tel;
    _pwd.text = pwd;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_login cutBorderWithBorderWidth:0 borderColor:0 cornerRadius:_login.height / 2];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
