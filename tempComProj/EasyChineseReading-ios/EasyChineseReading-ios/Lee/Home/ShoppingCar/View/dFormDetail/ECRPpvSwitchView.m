//
//  ECRPpvSwitchView.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRPpvSwitchView.h"

static CGFloat marginA = 20;
static NSString *fmTitle = @"满减劵";
static NSString *sdTitle = @"抵扣积分";
static NSString *cmNormal = @"333333";

@interface ECRPpvSwitchView ()

@property (strong,nonatomic) UIButton *fullMinus;//
@property (strong,nonatomic) UIButton *scoreDeductible;//
@property (strong,nonatomic) UIView   *efView;//

@end

@implementation ECRPpvSwitchView

- (void)textDependsLauguage{
    fmTitle = [LGPChangeLanguage localizedStringForKey:@"满减券"];
    sdTitle = [LGPChangeLanguage localizedStringForKey:@"积分抵扣"];
}

- (void)switchBtnWithOffsetX:(CGFloat)offsetX{
    if (offsetX < Screen_Width) {
        [self setBtnWithTag:ECRPpvSwitchViewSwitchTagFullminus block:nil];
    }
    if (offsetX == Screen_Width) {
       [self setBtnWithTag:ECRPpvSwitchViewSwitchTagScoreDedu block:nil];
    }
    
}

- (void)btnClick:(UIButton *)sender{
    // remake efView
    __weak typeof(self) weakSelf = self;
    [self setBtnWithTag:sender.tag block:^(CGPoint offsetPoint) {
        if ([weakSelf.delegate respondsToSelector:@selector(ppvsView:offsetPoint:)]) {
            [weakSelf.delegate ppvsView:weakSelf offsetPoint:offsetPoint];
        }
    }];
}

- (void)setBtnWithTag:(ECRPpvSwitchViewSwitchTag)tag block:(void(^)(CGPoint offsetPoint))block{
    CGPoint offsetPoint = CGPointZero;
    switch (tag) {
        case ECRPpvSwitchViewSwitchTagFullminus:{
            [self.efView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.fullMinus.titleLabel.mas_left);
                make.right.equalTo(self.fullMinus.titleLabel.mas_right);
                make.top.equalTo(self.fullMinus.mas_bottom);
                make.height.equalTo(@1);
            }];
            self.fullMinus.selected = YES;
            self.scoreDeductible.selected = NO;
            offsetPoint = CGPointMake(0, 0);
        }
            break;
        case ECRPpvSwitchViewSwitchTagScoreDedu:{
            [self.efView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scoreDeductible.titleLabel.mas_left);
                make.right.equalTo(self.scoreDeductible.titleLabel.mas_right);
                make.top.equalTo(self.scoreDeductible.mas_bottom);
                make.height.equalTo(@1);
            }];
            self.fullMinus.selected = NO;
            self.scoreDeductible.selected = YES;
            offsetPoint = CGPointMake((Screen_Width), 0);
        }
            break;
    }
    if (block) {
        block(offsetPoint);
    }
}

- (void)setupUI{
    [self textDependsLauguage];
    [self addSubview:self.fullMinus];
    [self addSubview:self.scoreDeductible];
    [self addSubview:self.efView];
    
    [self.fullMinus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.scoreDeductible mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullMinus.mas_right).offset(marginA);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.efView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullMinus.titleLabel.mas_left);
        make.right.equalTo(self.fullMinus.titleLabel.mas_right);
        make.top.equalTo(self.fullMinus.mas_bottom);
        make.height.equalTo(@1);
    }];
    self.fullMinus.selected = YES;
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
- (UIButton *)fullMinus{
    if (_fullMinus == nil) {
        _fullMinus = [[UIButton alloc] init];
        _fullMinus.tag = ECRPpvSwitchViewSwitchTagFullminus;
        [_fullMinus setTitle:fmTitle forState:UIControlStateNormal];
        [_fullMinus setTitleColor:[UIColor colorWithHexString:cmNormal] forState:UIControlStateNormal];
        [_fullMinus setTitleColor:self.currentThemeColor forState:UIControlStateSelected];
        [_fullMinus.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_fullMinus addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullMinus;
}
- (UIButton *)scoreDeductible{
    if (_scoreDeductible == nil) {
        _scoreDeductible = [[UIButton alloc] init];
        _scoreDeductible.tag = ECRPpvSwitchViewSwitchTagScoreDedu;
        [_scoreDeductible setTitle:sdTitle forState:UIControlStateNormal];
        [_scoreDeductible setTitleColor:[UIColor colorWithHexString:cmNormal] forState:UIControlStateNormal];
        [_scoreDeductible setTitleColor:self.currentThemeColor forState:UIControlStateSelected];
        [_scoreDeductible.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_scoreDeductible addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scoreDeductible;
}
- (UIView *)efView{
    if (_efView == nil) {
        _efView = [[UIView alloc] init];
        _efView.backgroundColor = self.currentThemeColor;
    }
    return _efView;
}
- (UIColor *)currentThemeColor{
    return [LGSkinSwitchManager currentThemeColor];
}
@end
