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
@property (weak, nonatomic) IBOutlet UITextField *verCodeText;
@property (weak, nonatomic) IBOutlet UIButton *verCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation EDJModifiPwdViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_verCodeButton cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:_verCodeButton.height * 0.5];
    [_verCodeButton setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    
    [_nextButton cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:_nextButton.height * 0.5];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:[UIColor EDJMainColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (IBAction)verClick:(id)sender {
    NSLog(@"验证码获取 -- ");
}


@end
