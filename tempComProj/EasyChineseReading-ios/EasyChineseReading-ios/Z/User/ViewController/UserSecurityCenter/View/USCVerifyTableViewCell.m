//
//  USCVerifyTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "USCVerifyTableViewCell.h"

@interface USCVerifyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewline;
@property (weak, nonatomic) IBOutlet UIImageView *imgVerification;

@end

@implementation USCVerifyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configVerifyTableViewCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateSystemLanguage
{
    _txtfVerity.placeholder = LOCALIZATION(@"请输入验证码");
    [_btnSendVerify setTitle:LOCALIZATION(@"获取验证码") forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark 配置界面

- (void)configVerifyTableViewCell
{
    _imgVerification.image = [UIImage imageNamed:@"icon_register_verification"];
    _viewline.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _txtfVerity.textColor = [UIColor cm_blackColor_333333_1];
    _txtfVerity.font = [UIFont systemFontOfSize:cFontSize_16];
    
    [_btnSendVerify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSendVerify addTarget:self action:@selector(click_btnSendVerify) forControlEvents:UIControlEventTouchUpInside];
    _btnSendVerify.backgroundColor = [UIColor cm_orangeColor_F2C782_1];
    _btnSendVerify.titleLabel.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _btnSendVerify.layer.masksToBounds = YES;
    _btnSendVerify.layer.cornerRadius = _btnSendVerify.height/2;
}

- (void)click_btnSendVerify
{
    if ([self.delegate respondsToSelector:@selector(sendVerifyCode)]) {
        [self.delegate sendVerifyCode];
    }
}

@end
