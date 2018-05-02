//
//  ECRBiCustomButton.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "LGCustomButton.h"

@interface LGCustomButton ()

@end

@implementation LGCustomButton

- (void)modifyTextColorWithColorString:(NSString *)colorString iconName:(NSString *)iconName{
    [self.label setTextColor:[UIColor colorWithHexString:colorString]];
    [self.img setImage:[UIImage imageNamed:iconName]];
    self.button.hidden = YES;
}

- (void)setBgColorStr:(NSString *)bgColorStr{
    self.backgroundColor = [UIColor colorWithHexString:bgColorStr];
}

- (void)setupWithImgName:(NSString *)imgName labelText:(NSString *)labelText labelTextColor:(NSString *)labelTextColor{
    [self.img setImage:[UIImage imageNamed:imgName]];
    [self.label setTextColor:[UIColor colorWithHexString:labelTextColor]];
    [self.label setText:labelText];
    
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.img];
    [self addSubview:self.label];
    [self addSubview:self.button];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.img.mas_centerX);
        make.top.equalTo(self.img.mas_bottom).offset(self.marginMid);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
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

#pragma mark - getter
- (UIImageView *)img{
    if (_img == nil) {
        _img = [UIImageView new];
        _img.contentMode = UIViewContentModeScaleAspectFit;
        _img.clipsToBounds = YES;
    }
    return _img;
}
- (UILabel *)label{
    if (_label == nil) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:self.lbFont];
    }
    return _label;
}
- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton new];
    }
    return _button;
}

#pragma mark - 用到的参数
- (CGFloat)margin{
    return 5;
}
- (CGFloat)marginMid{
    return 8;
}
- (CGFloat)lbFont{
    return 14;
}

@end
