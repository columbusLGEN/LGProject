//
//  EDJModifiPwdViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJModifiPwdViewController.h"
#import "UIButton+LGExtension.h"
#import "UCAccountHitSuccessView.h"

@interface EDJModifiPwdViewController ()<
UCAccountHitSuccessViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pnIcon;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *vcIcon;
@property (weak, nonatomic) IBOutlet UITextField *verCodeText;
/// 备注：如果是确认密码页面，则两个输入框中的文本内容是密码

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
        /// 重置密码 页面
        UIImage *lockIcon = [UIImage imageNamed:@"uc_icon_login_pwd_prefix"];
        [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
        _verCodeButton.hidden = YES;
        [_pnIcon setImage:lockIcon];
        [_vcIcon setImage:lockIcon];
        
        _phoneNumber.placeholder = @"请输入新密码";
        _verCodeText.placeholder = @"确认密码";
        _verCodeText.secureTextEntry = YES;
        _phoneNumber.secureTextEntry = YES;
        
        self.title = @"重置密码";
    }
}


/// MARK: 发送获取验证码请求
- (IBAction)verClick:(UIButton *)sender {
    
    /// 验证手机号
    BOOL canSend = [self verifiPhoneWith:_phoneNumber.text];
    if (canSend) {
        
        [[DJUserNetworkManager sharedInstance] userSendMsgWithPhone:_phoneNumber.text success:^(id responseObj) {
            [self presentFailureTips:@"发送成功,请注意查收"];
            [sender openCountdown];
        } failure:^(id failureObj) {
            if ([failureObj isKindOfClass:[NSDictionary class]]) {
                [self presentFailureTips:failureObj[@"msg"]];
            }else{
                [self presentFailureTips:@"发送验证码失败,请稍后重试"];
            }
        }];
    }
}

- (IBAction)doneClick:(UIButton *)sender {
    
    if (_coType == CodeOperationTypeConfirmPwd) {
        /// MARK: 修改密码 & 确认密码
        /// 验证手机号
        BOOL canSend = [self verifiPhoneWith:_phone];
        if (canSend) {
            /// 验证密码
            if (![_phoneNumber.text isPwd]) {
                [self presentFailureTips:@"密码为8-32为数字字母组合"];
                return;
            }
            if (![_phoneNumber.text isEqualToString:_verCodeText.text]) {
                [self presentFailureTips:@"两次输入的密码不一致"];
                return;
            }
            
            [[DJUserNetworkManager sharedInstance] userForgetChangePwdWithPhone:_phone newPwd:_phoneNumber.text oldPwd:@"" success:^(id responseObj) {
                /// 修改密码成功回调
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentFailureTips:@"修改成功,请登录"];
                    UCAccountHitSuccessView *sv = [[UCAccountHitSuccessView alloc] initWithFrame:self.view.bounds];
                    sv.delegate = self;
                    //    [self.view addSubview:sv];
                    [[UIApplication sharedApplication].keyWindow addSubview:sv];
                }];
                
            } failure:^(id failureObj) {
                NSLog(@"userForgetChangePwdWithPhone_failure: %@",failureObj);
                [self presentFailureTips:@"修改失败,请稍后重试"];
            }];
        }

    }
    
    if (_coType == CodeOperationTypeSendVerCode) {
        BOOL canSend = [self verifiPhoneWith:_phoneNumber.text];
        /// MARK: 验证 验证码
        if (canSend) {
            [[DJUserNetworkManager sharedInstance] userVerrifiCodeWithPhone:_phoneNumber.text code:_verCodeText.text success:^(id responseObj) {
               NSLog(@"验证验证码成功: %@",responseObj);
                /// 跳转至 确认新密码页面
                EDJModifiPwdViewController *vc = (EDJModifiPwdViewController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"EDJModifiPwdViewController"];
                
                vc.coType = CodeOperationTypeConfirmPwd;
                vc.phone  = _phoneNumber.text;
                
                [self.navigationController pushViewController:vc animated:YES];
            } failure:^(id failureObj) {
                [self presentFailureTips:@"验证失败,请输入正确的验证码或稍后重试"];
            }];
        }
        
    }
    
}


#pragma mark - UCAccountHitSuccessViewDelegate
- (void)removehsView{
    /// 设置成功页面销毁的回调
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (BOOL)verifiPhoneWith:(NSString *)phoneNumber{
    
    if (phoneNumber == nil || [phoneNumber isEqualToString:@""]) {
        [self presentFailureTips:@"请输入手机号"];
        return NO;
    }
    if (![phoneNumber isPhone]) {
        [self presentFailureTips:@"手机号格式错误"];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
