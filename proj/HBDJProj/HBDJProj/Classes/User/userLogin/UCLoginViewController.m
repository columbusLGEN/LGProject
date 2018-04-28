//
//  UCLoginViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCLoginViewController.h"

@interface UCLoginViewController ()
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



@end
