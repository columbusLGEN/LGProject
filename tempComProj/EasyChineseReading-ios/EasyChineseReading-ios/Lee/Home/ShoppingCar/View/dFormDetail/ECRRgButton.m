//
//  ECRRgButton.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRRgButton.h"

static CGFloat marginA   = 15;

@interface ECRRgButton ()
@property (strong,nonatomic) UIImageView *icon;//

@end

@implementation ECRRgButton

- (void)setUserCanCLick:(BOOL)userCanCLick{
    _userCanCLick = userCanCLick;
    self.btn.userInteractionEnabled = userCanCLick;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    [self iconImageWithSelected:selected];
}
- (void)myselfStateChange:(UIButton *)sender{
    if (self.selected) {
        self.selected = NO;
    }else{
        self.selected = YES;
    }
    sender.selected = self.selected;
}
- (void)iconImageWithSelected:(BOOL)selected{
    if (selected) {
        [self.icon setImage:[UIImage imageNamed:self.icNameSelected]];
    }else{
        [self.icon setImage:[UIImage imageNamed:self.icNameNormal]];
    }
}
- (void)setIcNameNormal:(NSString *)icNameNormal{
    _icNameNormal = icNameNormal;
    [self.icon setImage:[UIImage imageNamed:icNameNormal]];
}

- (void)setRgtlText:(NSString *)rgtlText{
    _rgtlText = rgtlText;
    [self.rgtLable setText:rgtlText];
}
- (void)setRgtlTextColor:(UIColor *)rgtlTextColor{
    _rgtlTextColor = rgtlTextColor;
    [self.rgtLable setTextColor:rgtlTextColor];
}
- (void)setRgtlFont:(CGFloat)rgtlFont{
    _rgtlFont = rgtlFont;
    [self.rgtLable setFont:[UIFont systemFontOfSize:rgtlFont]];
}

- (void)setupUI{
    [self addSubview:self.icon];
    [self addSubview:self.rgtLable];
    [self addSubview:self.btn];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.rgtLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(marginA);
        make.centerY.equalTo(self.icon.mas_centerY);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_left);
        make.right.equalTo(self.rgtLable.mas_right);
        make.centerY.equalTo(self.rgtLable.mas_centerY);
        make.height.equalTo(@40);
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

- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}
- (UILabel *)rgtLable{
    if (_rgtLable == nil) {
        _rgtLable = [[UILabel alloc] init];
    }
    return _rgtLable;
}
- (UIButton *)btn{
    if (_btn == nil) {
        _btn = [[UIButton alloc] init];
//        [_btn setBackgroundColor:[UIColor redColor]];
//        _btn.alpha = 0.1;
        [_btn addTarget:self
                 action:@selector(myselfStateChange:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end


