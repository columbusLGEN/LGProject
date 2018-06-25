//
//  UCLoginViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCLoginViewController.h"
#import "UCAccountHitViewController.h"
#import "NSString+Extension.h"
#import "DJUser.h"

#import "LIGMainTabBarController.h"

@interface UCLoginViewController ()<
UCAccountHitViewControllerDelegate
,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (assign,nonatomic) BOOL pwdIsSecureEntry;

@end

@implementation UCLoginViewController

- (void)setNavLeftBackItem{
    if (_canBack) {
        [super setNavLeftBackItem];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户登录";
    
    _pwd.delegate = self;
    
    _pwdIsSecureEntry = _pwd.isSecureTextEntry;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = updateString;
    return NO;
}

- (IBAction)displayPwd:(id)sender {
    if (_pwdIsSecureEntry) {
        _pwd.secureTextEntry = NO;
    }else{
        _pwd.secureTextEntry = YES;
    }
    _pwdIsSecureEntry = _pwd.isSecureTextEntry;
}
- (IBAction)forgetPwd:(id)sender {
    /// 忘记密码
}

- (IBAction)login:(id)sender {
    [[DJUser new] keepUserInfo];
    /// 登录
    if (![_username.text isPhone]) {
        [self.view presentFailureTips:@"请输入正确的手机号"];

    }else if (![_pwd.text isPwd]) {
        [self.view presentFailureTips:@"请输入正确的密码"];

    }else{
        [self ucanLoginWithTel:_username.text pwd:_pwd.text];
    }
}
/// 账号激活
- (IBAction)acountHit:(UIButton *)sender {
    UCAccountHitViewController *hvc = (UCAccountHitViewController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCAccountHitViewController"];
    hvc.delegate = self;
    
    [self.navigationController pushViewController:hvc animated:YES];
}

#pragma mark - UCAccountHitViewController
- (void)ucanLoginWithTel:(NSString *)tel pwd:(NSString *)pwd{
    NSLog(@"发送登陆请求: tel: %@ -- pwd: %@",tel,pwd);
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
        
        /// 1.保存用户信息
        /// 2.重新加载 keywindow 的 root vc
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        DJUser *user = [DJUser mj_objectWithKeyValues:responseObj];
        [user keepUserInfo];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_login cutBorderWithBorderWidth:0 borderColor:0 cornerRadius:_login.height / 2];
}

@end
