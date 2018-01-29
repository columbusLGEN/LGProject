
//
//  RButtonTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "RButtonTableViewCell.h"

@interface RButtonTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@end

@implementation RButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _btnRegister.layer.masksToBounds = YES;
    _btnRegister.layer.cornerRadius = _btnRegister.height/2;
    
    _btnRegister.enabled = NO;
    _btnRegister.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    [_btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRegister setTitle:LOCALIZATION(@"立即注册") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 点击注册 */
- (IBAction)click_btnRegister:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerNow)]) {
        [self.delegate registerNow];
    }
}

/** 更新注册按键颜色状态 */
- (void)updateButtonEnable:(BOOL)btnEnable
{
    _btnRegister.enabled = btnEnable;
    _btnRegister.backgroundColor = btnEnable ? [UIColor cm_mainColor] : [UIColor cm_grayColor__F1F1F1_1];
}

@end
