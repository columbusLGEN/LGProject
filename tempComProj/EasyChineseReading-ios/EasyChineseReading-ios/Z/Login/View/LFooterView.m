//
//  LFooterView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LFooterView.h"

#import "WXApi.h"

@interface LFooterView ()

/* view in headerView */
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@property (weak, nonatomic) IBOutlet UILabel *lblDescTop;

@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;

/* view in footerView */
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *lblRegister;
@property (weak, nonatomic) IBOutlet UILabel *lblForgetPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblRegisterInOrganization;

@end

@implementation LFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configFooterView];
    [self addGestureRecognizer];
}

// 根据登录类型修改调整界面
- (void)setLoginType:(NSInteger)loginType
{
    _headerViewHeightConstraint.constant = loginType == ENUM_UserTypeOrganization || ![WXApi isWXAppInstalled] ? 1.f : 100.f;
    _lblRegister.hidden               = loginType == ENUM_UserTypeOrganization;
    _lblForgetPassword.hidden         = loginType == ENUM_UserTypeOrganization;
    _lblRegisterInOrganization.hidden = loginType != ENUM_UserTypeOrganization;
    _bottomLine.hidden                = loginType == ENUM_UserTypeOrganization;
}

#pragma mark - 配置footerView

- (void)updateSystemLanguage
{
    _lblDescTop.text                = LOCALIZATION(@"使用合作网站登录");
    _lblRegister.text               = LOCALIZATION(@"立即注册");
    _lblForgetPassword.text         = LOCALIZATION(@"忘记密码");
    _lblRegisterInOrganization.text = LOCALIZATION(@"立即注册");
}

- (void)configFooterView
{
    _imgLeft.hidden    = ![WXApi isWXAppInstalled];
    _leftLine.hidden   = ![WXApi isWXAppInstalled];
    _rightLine.hidden  = ![WXApi isWXAppInstalled];
    _lblDescTop.hidden = ![WXApi isWXAppInstalled];
    _imgRight.hidden   = YES;
    
    _imgLeft.image  = [UIImage imageNamed:@"icon_login_wechat"];
    _imgRight.image = [UIImage imageNamed:@"icon_login_beiyushe"];
    
    _leftLine.backgroundColor  = [UIColor cm_blackColor_333333_1];
    _rightLine.backgroundColor = [UIColor cm_blackColor_333333_1];
    
    _lblDescTop.textColor                = [UIColor cm_blackColor_333333_1];
    _lblRegister.textColor               = [UIColor cm_blackColor_666666_1];
    _lblForgetPassword.textColor         = [UIColor cm_blackColor_666666_1];
    _lblRegisterInOrganization.textColor = [UIColor cm_blackColor_666666_1];
    
    UIFont *font = [UIFont systemFontOfSize:[IPhoneVersion deviceSize] <= iPhone4inch ? cFontSize_12 : cFontSize_14];
    _lblDescTop.font                = font;
    _lblRegister.font               = font;
    _lblForgetPassword.font         = font;
    _lblRegisterInOrganization.font = font;
    
}

#pragma mark - 添加点击手势

- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap_imgLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgLeft)];
    [_imgLeft addGestureRecognizer:tap_imgLeft];
    UITapGestureRecognizer *tap_imgRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgRight)];
    [_imgRight addGestureRecognizer:tap_imgRight];
    UITapGestureRecognizer *tap_lblRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLblRegister)];
    [_lblRegister addGestureRecognizer:tap_lblRegister];
    UITapGestureRecognizer *tap_lblRegisterInOrganization = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLblRegister)];
    [_lblRegisterInOrganization addGestureRecognizer:tap_lblRegisterInOrganization];
    UITapGestureRecognizer *tap_lblForgetPassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLblForgetPassword)];
    [_lblForgetPassword addGestureRecognizer:tap_lblForgetPassword];
}

/** 左侧第三方登录 */
- (void)tapImgLeft {
    if ([self.delegate respondsToSelector:@selector(loginByIndex:)]) {
        [self.delegate loginByIndex:0];
    }
}

/** 右侧第三方登录 */
- (void)tapImgRight {
    if ([self.delegate respondsToSelector:@selector(loginByIndex:)]) {
        [self.delegate loginByIndex:1];
    }
}

/** 快速注册 */
- (void)tapLblRegister {
    if ([self.delegate respondsToSelector:@selector(registerNow)]) {
        [self.delegate registerNow];
    }
}

/** 忘记密码 */
- (void)tapLblForgetPassword {
    if ([self.delegate respondsToSelector:@selector(forgetPassword)]) {
        [self.delegate forgetPassword];
    }
}

@end
