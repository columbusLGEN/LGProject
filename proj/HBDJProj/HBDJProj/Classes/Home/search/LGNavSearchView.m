//
//  LGNavSearchView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGNavSearchView.h"

static CGFloat containerBtnHeight = 34;

@interface LGNavSearchView ()<
UITextFieldDelegate>
@property (strong,nonatomic) UIButton *backBtn;
@property (strong,nonatomic) UIImageView *leftIcon;
//@property (strong,nonatomic) UIButton *containerBtn;
@property (strong,nonatomic) UIButton *voiceBtn;
@property (strong,nonatomic) UITextField *search;
@property (strong,nonatomic) UIView *baseLine;

@end

@implementation LGNavSearchView

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.leftIcon.hidden = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (void)backBtnClick:(id)sender{
    /// 通知控制器,返回上一级
    if ([self.delegate respondsToSelector:@selector(navSearchViewBack:)]) {
        [self.delegate navSearchViewBack:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_search cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_search.height * 0.5];
}

- (void)configUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backBtn];
    [self addSubview:self.search];
    [self addSubview:self.leftIcon];
    [self addSubview:self.voiceBtn];
    [self addSubview:self.baseLine];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginTwelve);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
    }];
    [self.leftIcon  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.voiceBtn.mas_centerY);
        make.centerX.equalTo(self.search.mas_centerX).offset(-marginTwenty*3 - marginTen);
    }];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY).offset(-marginFive);
        make.right.equalTo(self.mas_right).offset(-(30+marginTwelve));
    }];
    [self.baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-30);
        make.centerY.equalTo(self.backBtn.mas_centerY).offset(-marginFive);
        make.height.mas_equalTo(containerBtnHeight);
    }];
    
}
- (UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"icon_arrow_left_black"] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -marginTwenty, marginTen, 0)];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)voiceBtn{
    if (_voiceBtn == nil) {
        _voiceBtn = [UIButton new];
        [_voiceBtn setImage:[UIImage imageNamed:@"home_nav_voice"] forState:UIControlStateNormal];
//        _voiceBtn addTarget:<#(nullable id)#> action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
    }
    return _voiceBtn;
}
- (UIImageView *)leftIcon{
    if (_leftIcon == nil) {
        _leftIcon = [UIImageView new];
        _leftIcon.image = [UIImage imageNamed:@"home_nav_search"];
    }
    return _leftIcon;
}
- (UITextField *)search{
    if (_search == nil) {
        _search = [UITextField new];
        _search.backgroundColor = [self txtFeildBackgroundColor];
        _search.textAlignment = NSTextAlignmentCenter;
        _search.placeholder = @"搜索你想要的";
        _search.delegate = self;
    }
    return _search;
}
- (UIView *)baseLine{
    if (_baseLine == nil) {
        _baseLine = [UIView new];
        _baseLine.backgroundColor = [UIColor EDJGrayscale_F3];
    }
    return _baseLine;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}
- (UIColor *)txtFeildBackgroundColor{
    return [UIColor EDJGrayscale_F3];
}

@end
