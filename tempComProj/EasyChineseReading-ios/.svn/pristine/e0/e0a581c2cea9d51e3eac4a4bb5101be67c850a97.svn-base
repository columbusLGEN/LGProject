//
//  LButtonTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LButtonTableViewCell.h"

@implementation LButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = _btnLogin.height/2;
    [_btnLogin setTitle:LOCALIZATION(@"立即登录") forState:UIControlStateNormal];

    _btnLogin.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    _btnLogin.titleLabel.font = [UIFont systemFontOfSize:cFontSize_14];
    _btnLogin.enabled = NO;
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// 点击登录
- (IBAction)click_btnLogin:(id)sender {
    if ([self.delegate respondsToSelector:@selector(login)]) {
        [self.delegate login];
    }
}

// 更新登录按钮的颜色与状态
- (void)updateButtonEnable:(BOOL)btnEnable {
    _btnLogin.enabled = btnEnable;
    _btnLogin.backgroundColor = btnEnable ? [UIColor cm_mainColor] : [UIColor cm_grayColor__F1F1F1_1];
}

@end
