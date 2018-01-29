//
//  LVerifyTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LVerifyTableViewCell.h"

static CGFloat const kBtnWidth_pad   = 150.f;
static CGFloat const kBtnWidth_phone = 120.f;

@interface LVerifyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthSendConstraint;

@end

@implementation LVerifyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _txtfContent.font = [UIFont systemFontOfSize:[IPhoneVersion deviceSize] <= iPhone4inch ? cFontSize_14 : cFontSize_16];
    _txtfContent.keyboardType = UIKeyboardTypeNumberPad;
    
    [_sendVerify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendVerify.backgroundColor = [UIColor cm_orangeColor_F2C782_1];
    _sendVerify.layer.masksToBounds = YES;
    _sendVerify.layer.cornerRadius = _sendVerify.height/2;
    
    _widthSendConstraint.constant = isPad ? kBtnWidth_pad : kBtnWidth_phone;
    
    _txtfContent.placeholder = LOCALIZATION(@"请输入验证码");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dataDidChange {
    NSDictionary *dic = self.data;
    _imgIcon.image           = [UIImage imageNamed:dic[@"icon"]];
    _txtfContent.placeholder = dic[@"placeHolder"];
    _txtfContent.tag         = [dic[@"index"] integerValue];
    if (dic[@"btnText"])
        [_sendVerify setTitle:dic[@"btnText"] forState:UIControlStateNormal];
}

// 发送验证码
- (IBAction)click_sendVerify:(id)sender {
    [self.delegate sendVerifyCode];
}

// 取消第一响应者
- (void)resignAllFirstResponder {
    [_txtfContent resignFirstResponder];
}

@end
