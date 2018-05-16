//
//  EDJModifiPwdViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJModifiPwdViewController.h"

@interface EDJModifiPwdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pnIcon;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *vcIcon;
@property (weak, nonatomic) IBOutlet UITextField *verCodeText;
/** 重置密码：隐藏 */
@property (weak, nonatomic) IBOutlet UIButton *verCodeButton;
/** 找回密码：下一步；重置密码：确定 */
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation EDJModifiPwdViewController


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_verCodeButton cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_verCodeButton.height * 0.5];
    
    [_nextButton cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:_nextButton.height * 0.5];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:[UIColor EDJMainColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_verCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verCodeButton setBackgroundColor:[UIColor EDJMainColor]];

    if (_coType == CodeOperationTypeConfirmPwd) {
        /// 重置密码
        UIImage *lockIcon = [UIImage imageNamed:@"uc_icon_login_pwd_prefix"];
        [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
        _verCodeButton.hidden = YES;
        [_pnIcon setImage:lockIcon];
        [_vcIcon setImage:lockIcon];
        
        _phoneNumber.placeholder = @"请输入新密码";
        _verCodeText.placeholder = @"确认密码";
        self.title = @"重置密码";
    }
}

- (IBAction)verClick:(id)sender {
    NSLog(@"验证码获取 -- ");
}

- (IBAction)doneClick:(UIButton *)sender {
    
    if (_coType == CodeOperationTypeSendVerCode) {
        /// 获取验证码
        EDJModifiPwdViewController *vc = (EDJModifiPwdViewController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"EDJModifiPwdViewController"];
        vc.coType = CodeOperationTypeConfirmPwd;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
