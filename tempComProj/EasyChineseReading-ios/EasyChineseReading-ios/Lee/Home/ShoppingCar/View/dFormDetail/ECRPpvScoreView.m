//
//  ECRPpvScoreView.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRPpvScoreView.h"
#import "ECRRgButton.h"

static CGFloat spaceA = 10;
static CGFloat spaceB = 15;
static CGFloat heightA = 50;
static NSString *colors = @"333333";
static NSString *icon_selected_no = @"icon_selected_no";
static NSString *icon_selected = @"icon_selected";

@interface ECRPpvScoreView ()

/** 提示信息label */
@property (strong,nonatomic) UILabel *deduInfo;//
@end

@implementation ECRPpvScoreView

- (void)setUserCanCLick:(BOOL)userCanCLick{
    _userCanCLick = userCanCLick;
    self.userScore.userCanCLick = userCanCLick;
}

- (void)setAvaScore:(NSInteger)avaScore{
    _avaScore = avaScore;
}

- (void)setIntegralrate:(NSInteger)integralrate{
    _integralrate = integralrate;
//    [self textDependsLauguage];
    NSInteger scoreAvilable = _avaScore;// TODO: 积分汇率
    NSInteger dedu = _avaScore / _integralrate;
    
    NSString *canUseScore_0 = [self locaStringWithString:@"可使用抵扣"];
    NSString *canUseScore_1 = [self locaStringWithString:@"积分，抵扣"];
    NSString *canUseScore_2 = [self locaStringWithString:@"虚拟币。"];
    
    //    NSString *deduInfoText = [NSString stringWithFormat:@"可使用抵扣%ld积分，抵扣：%ld虚拟币",scoreAvilable,dedu];
    NSString *deduInfoText = [NSString stringWithFormat:@"%@%ld%@: %ld%@",canUseScore_0,scoreAvilable,canUseScore_1,dedu,canUseScore_2];
    if (_userCanCLick) {
        self.deduInfo.text = deduInfoText;
    }else{
        self.deduInfo.text = LOCALIZATION(@"积分抵扣条件不足");
    }
}

- (NSString *)locaStringWithString:(NSString *)oriString{
    return [LGPChangeLanguage localizedStringForKey:oriString];
}

- (void)setPriceYu:(NSInteger)priceYu{
    _priceYu = priceYu;
//    [self textDependsLauguage];
    NSString *userScore_0 = [self locaStringWithString:@"使用积分"];
    NSString *userScore_1 = [self locaStringWithString:@"当前余额"];
    
    //    _priceYu = 200;
    NSString *rgtlText = [NSString stringWithFormat:@"%@ (%@：%ld)",userScore_0,userScore_1,_priceYu];
    self.userScore.rgtlText = rgtlText;
}

- (void)setupUI{
    [self addSubview:self.userScore];
    [self addSubview:self.deduInfo];
    
    [self.userScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(spaceA);
        make.top.equalTo(self.mas_top).offset(spaceB);
        make.right.equalTo(self.mas_right).offset(-spaceA);
        make.height.equalTo(@(heightA));
    }];
    [self.deduInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userScore.rgtLable.mas_left);
        make.top.equalTo(self.userScore.mas_bottom).offset(0);
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
- (ECRRgButton *)userScore{
    if (_userScore == nil) {
        _userScore = [[ECRRgButton alloc] init];
        _userScore.icNameNormal = icon_selected_no;
        _userScore.icNameSelected = icon_selected;
        
        _userScore.rgtlTextColor = [UIColor colorWithHexString:colors];
        _userScore.rgtlFont = 14;
    }
    return _userScore;
}
- (UILabel *)deduInfo{
    if (_deduInfo == nil) {
        _deduInfo = [[UILabel alloc] init];
        _deduInfo.textColor = [UIColor colorWithHexString:colors];
        _deduInfo.font = [UIFont systemFontOfSize:14];
    }
    return _deduInfo;
}

@end
