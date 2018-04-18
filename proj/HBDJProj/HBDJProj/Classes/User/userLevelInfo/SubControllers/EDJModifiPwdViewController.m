//
//  EDJModifiPwdViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJModifiPwdViewController.h"

@interface EDJModifiPwdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *pwd;
@property (weak, nonatomic) IBOutlet UIButton *verCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation EDJModifiPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)verClick:(id)sender {
    NSLog(@"验证码获取 -- ");
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
