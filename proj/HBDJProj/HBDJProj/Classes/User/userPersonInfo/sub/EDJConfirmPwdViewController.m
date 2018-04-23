//
//  EDJConfirmPwdViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJConfirmPwdViewController.h"

@interface EDJConfirmPwdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pwd;
@property (weak, nonatomic) IBOutlet UILabel *confirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *confirm;

@end

@implementation EDJConfirmPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认密码";
    // Do any additional setup after loading the view.
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
