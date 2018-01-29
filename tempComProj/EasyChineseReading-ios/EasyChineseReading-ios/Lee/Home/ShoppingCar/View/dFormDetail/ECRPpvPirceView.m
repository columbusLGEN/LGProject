//
//  ECRPpvPirceView.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRPpvPirceView.h"

static NSString *vrcText = @"虚拟币余额：";
static CGFloat fontc = 14;// common
static NSString *colors = @"333333";

@interface ECRPpvPirceView ()
@property (strong,nonatomic) UILabel *virtualCoin;//
@property (strong,nonatomic) UILabel *vrCoinCount;//
@property (strong,nonatomic) UIView  *line;//

@end

@implementation ECRPpvPirceView

- (void)textDependsLauguage{
    vrcText = [NSString stringWithFormat:@"%@",[LGPChangeLanguage localizedStringForKey:@"虚拟币"]];
    self.vrCoinCount.text = [NSString stringWithFormat:@"%@%@",_priceYu,vrcText];
}

- (void)setPriceYu:(NSString *)priceYu{
    _priceYu = priceYu;
    [self textDependsLauguage];

}

- (void)setupUI{
    [self textDependsLauguage];
    [self addSubview:self.virtualCoin];
    [self addSubview:self.vrCoinCount];
    [self addSubview:self.line];
    [self.virtualCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.vrCoinCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
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
- (UILabel *)virtualCoin{
    if (_virtualCoin == nil) {
        _virtualCoin = [[UILabel alloc] init];
        _virtualCoin.text = [NSString stringWithFormat:@"%@ : ",vrcText];
        _virtualCoin.textColor = [UIColor colorWithHexString:colors];
        _virtualCoin.font = [UIFont systemFontOfSize:fontc];
    }
    return _virtualCoin;
}
- (UILabel *)vrCoinCount{
    if (_vrCoinCount == nil) {
        _vrCoinCount = [[UILabel alloc] init];
        _vrCoinCount.textColor = [UIColor colorWithHexString:colors];
        _vrCoinCount.font = [UIFont systemFontOfSize:fontc];
    }
    return _vrCoinCount;
}
- (UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    }
    return _line;
}

@end
