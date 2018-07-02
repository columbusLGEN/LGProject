//
//  DJChangePwdViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJChangePwdViewController.h"

@interface DJChangePwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *pwdNew;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *done;

@end

@implementation DJChangePwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)done:(id)sender {
    
    if ([_oldPwd.text isEqualToString:@""] || _oldPwd.text == nil) {
        [self presentFailureTips:@"请输入原密码"];
        return;
    }
    if ([_pwdNew.text isEqualToString:@""] || _pwdNew.text == nil) {
        [self presentFailureTips:@"请输入新密码"];
        return;
    }
    if ([_confirmPwd.text isEqualToString:@""] || _confirmPwd.text == nil) {
        [self presentFailureTips:@"请再次输入新密码"];
        return;
    }
    
    /// 验证密码
    if (![_pwdNew.text isPwd]) {
        [self presentFailureTips:@"密码为8-32为数字字母组合"];
        return;
    }
    if (![_pwdNew.text isEqualToString:_confirmPwd.text]) {
        [self presentFailureTips:@"两次输入的密码不一致"];
        return;
    }
    
    [[DJUserNetworkManager sharedInstance] userUpdatePwdWithOld:_oldPwd.text newPwd:_pwdNew.text success:^(id responseObj) {
        [self presentFailureTips:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id failureObj) {
        [self presentFailureTips:@"修改失败,请稍后重试"];
    }];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [_done cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_done.height * 0.5];
}

@end
