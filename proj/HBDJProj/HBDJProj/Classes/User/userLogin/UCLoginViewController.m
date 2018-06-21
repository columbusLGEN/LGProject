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

@interface UCLoginViewController ()<
UCAccountHitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (assign,nonatomic) BOOL pwdIsSecureEntry;

@end

@implementation UCLoginViewController

- (IBAction)displayPwd:(id)sender {
    if (_pwdIsSecureEntry) {
        _pwd.secureTextEntry = NO;
    }else{
        _pwd.secureTextEntry = YES;
    }
    _pwdIsSecureEntry = _pwd.isSecureTextEntry;
}
- (IBAction)forgetPwd:(id)sender {
    
}
- (IBAction)login:(id)sender {
    
}
/// 账号激活
- (IBAction)acountHit:(UIButton *)sender {
    UCAccountHitViewController *hvc = (UCAccountHitViewController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCAccountHitViewController"];
    hvc.delegate = self;
    
    [self.navigationController pushViewController:hvc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_login cutBorderWithBorderWidth:0 borderColor:0 cornerRadius:_login.height / 2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户登录";
    _pwdIsSecureEntry = _pwd.isSecureTextEntry;
}

#pragma mark - UCAccountHitViewController
- (void)ucanLoginWithTel:(NSString *)tel pwd:(NSString *)pwd{
    NSLog(@"发送登陆请求: tel: %@ -- pwd: %@",tel,pwd);
    
    /// TODO: 对密码进行 MD5
    NSString *pwd_md5 = pwd;
    [[DJNetworkManager sharedInstance] userLoginWithTel:tel pwd_md5:pwd_md5 success:^(id responseObj) {
        NSLog(@"userlogin: %@",responseObj);
        [DJUser sharedInstance];
        
    } failure:^(id failureObj) {
        NSLog(@"userloging_failure: %@",failureObj);
    }];
}

@end
