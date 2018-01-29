//
//  LGCartIcon.m
//  RGTestPorject
//
//  Created by Peanut Lee on 2017/12/20.
//  Copyright © 2017年 Lee. All rights reserved.
//
static CGFloat marginFive = 5;
static CGFloat countBgWidth = 16;
static CGFloat countTextFount = 10;
static NSString * const iconImageName = @"icon_shop_car_white";

#define countTextColor [UIColor whiteColor]
#define countBgColor [UIColor redColor]

#import "LGCartIcon.h"

@interface LGCartIcon ()
/** 购物车图标 */
@property (strong,nonatomic) UIImageView *icon;
/** 数量label */
@property (strong,nonatomic) UILabel *count;
/** 数量label bg */
@property (strong,nonatomic) UIView *countBg;
@end

@implementation LGCartIcon

- (void)setIconImgName:(NSString *)iconImgName{
    _iconImgName = iconImgName;
    if (iconImgName == nil) {
        _iconImgName = @"icon_shop_car_white";
    }
    self.icon.image = [UIImage imageNamed:_iconImgName];
}

// 设置数量
- (void)setCartCount:(NSInteger)cartCount{
    _cartCount = cartCount;
    if (cartCount != 0) {
        self.count.text = [NSString stringWithFormat:@"%ld",cartCount];
        self.countBg.hidden = NO;
    }else{
        self.countBg.hidden = YES;
    }
}

- (void)setupUI{
    [self addSubview:self.icon];
    [self addSubview:self.countBg];
    [self.countBg addSubview:self.count];
    [self addSubview:self.button];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    [self.countBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(countBgWidth));
        make.width.equalTo(@(countBgWidth));
        make.top.equalTo(self.icon.mas_top).offset(-marginFive);
        make.right.equalTo(self.icon.mas_right).offset(1.5 * marginFive);
    }];
    [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.countBg.mas_centerX);
        make.centerY.equalTo(self.countBg.mas_centerY);
    }];
    self.countBg.hidden = YES;
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
        _icon = [UIImageView new];
        _icon.image = [UIImage imageNamed:iconImageName];
    }
    return _icon;
}
- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton new];
    }
    return _button;
}
- (UIView *)countBg{
    if (_countBg == nil) {
        _countBg = [UIView new];
        _countBg.backgroundColor = countBgColor;
        _countBg.layer.cornerRadius = countBgWidth * 0.5;
        _countBg.layer.masksToBounds = YES;
    }
    return _countBg;
}
- (UILabel *)count{
    if (_count == nil) {
        _count = [UILabel new];
        _count.font = [UIFont systemFontOfSize:countTextFount];
        _count.textColor = countTextColor;

    }
    return _count;
}
@end
