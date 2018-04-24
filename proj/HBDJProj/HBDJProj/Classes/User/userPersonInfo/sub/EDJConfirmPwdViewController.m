//
//  EDJConfirmPwdViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJConfirmPwdViewController.h"

@interface EDJConfirmPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *confirm;

@end

@implementation EDJConfirmPwdViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_confirm cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:_confirm.height * 0.5];
    [_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirm setBackgroundColor:[UIColor EDJMainColor]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmClick:(id)sender {
    NSLog(@"确人密码 -- ");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
