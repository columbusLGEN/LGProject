//
//  ECRTopupFieldView.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRTopupFieldView.h"

static NSString *colors = @"333333";

@interface ECRTopupFieldView ()

@property (strong,nonatomic) UIButton    *done;             //

@end

@implementation ECRTopupFieldView

- (void)textDependsLauguage{
    
    [self.done setTitle:[LGPChangeLanguage localizedStringForKey:_buttonTitle] forState:UIControlStateNormal];
}

- (void)setTextFieldTitle_test:(NSString *)textFieldTitle_test{
    _textFieldTitle_test = textFieldTitle_test;
    self.textField.text = textFieldTitle_test;
}
- (void)setButtonTitle:(NSString *)buttonTitle{
    _buttonTitle = buttonTitle;
    [self textDependsLauguage];
}
- (void)setTextFontSize:(CGFloat)textFontSize{
    _textFontSize = textFontSize;
    [self.textField setFont:[UIFont systemFontOfSize:textFontSize]];
    [self.done.titleLabel setFont:[UIFont systemFontOfSize:textFontSize]];
}

- (void)setupUI{
    // TODO: 暂时指定高度 后期优化--> 高度由外部指定
    CGFloat heightSelf = 36;//self.bounds.size.height;
    CGFloat marginA = 15;
    [self addSubview:self.textField];
    [self addSubview:self.done];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top    .equalTo(self.mas_top).offset(marginA);
        make.left   .equalTo(self.mas_left).offset(marginA);
        make.height .equalTo(@(heightSelf));//
        make.right  .equalTo(self.done.mas_left).offset(1);
    }];
    [self.done mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textField.mas_centerY);
        make.right  .equalTo(self.mas_right).offset(-marginA);
        make.width  .equalTo(@80);
        make.height .equalTo(@(heightSelf));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        UIView *leftSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _textField.leftView          = leftSpace;
        _textField.leftViewMode      = UITextFieldViewModeAlways;
        _textField.textColor         = [UIColor colorWithHexString:colors];
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = [UIColor colorWithRed:(CGFloat)0xe3/0xff
                                                       green:(CGFloat)0xe3/0xff
                                                        blue:(CGFloat)0xe3/0xff
                                                       alpha:1].CGColor;
        _textField.borderStyle = UITextBorderStyleNone;
    }
    return _textField;
}
- (UIButton *)done{
    if (_done == nil) {
        _done = [[UIButton alloc] init];
        _done.layer.borderWidth = 1;
        _done.layer.borderColor = [UIColor colorWithRed:(CGFloat)0xe3/0xff
                                                  green:(CGFloat)0xe3/0xff
                                                   blue:(CGFloat)0xe3/0xff
                                                  alpha:1].CGColor;
        [_done setTitleColor:[UIColor cm_mainColor]
                    forState:UIControlStateNormal];
    }
    return _done;
}

@end
