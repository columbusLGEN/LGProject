//
//  ECRBookFormTopView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookFormTopView.h"

static CGFloat offsetx = -30;
static CGFloat fontb = 22;// big
static CGFloat fonts = 14;// small
static NSString *colorb = @"333333";

@interface ECRBookFormTopView ()
/** 虚拟币符号 */
@property (strong,nonatomic) UIImageView *vrIcon;//
@property (strong,nonatomic) UILabel *price;//
@property (strong,nonatomic) UILabel *priceDup;// 

@end

@implementation ECRBookFormTopView

- (void)textDependsLauguage{
    NSString *virtualCoin = @"虚拟币";
    NSString *pdString = [NSString stringWithFormat:@"( %@ )",[LGPChangeLanguage localizedStringForKey:virtualCoin]];// 该方法截取到的位置不包括 index
    [self.priceDup setText:pdString];
    [self.priceDup sizeToFit];
}

- (void)setPriceTotal:(NSString *)priceTotal{
    _priceTotal = priceTotal;
    [self.price setText:[NSString stringWithFormat:@"%@",priceTotal]];
    [self textDependsLauguage];
}


- (void)setupUI{
    [self addSubview:self.vrIcon];
    [self addSubview:self.price];
    [self addSubview:self.priceDup];
    
    [self.vrIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.price.mas_centerY).offset(2);
//        make.bottom.equalTo(self.price.mas_bottom);
        make.right.equalTo(self.price.mas_left).offset(-4);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(offsetx);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    [self.priceDup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.price.mas_centerY);
        make.left.equalTo(self.price.mas_right).offset(5);
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
- (UIImageView *)vrIcon{
    if (_vrIcon == nil) {
        _vrIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_virtual_currency_big"]];
    }
    return _vrIcon;
}
- (UILabel *)price{
    if (_price == nil) {
        _price = [[UILabel alloc] init];
        [_price setTextColor:[UIColor colorWithHexString:colorb]];
        [_price setFont:[UIFont systemFontOfSize:fontb]];
    }
    return _price;
}
- (UILabel *)priceDup{
    if (_priceDup == nil) {
        _priceDup = [[UILabel alloc] init];
        [_priceDup setTextColor:[UIColor colorWithHexString:colorb]];
        [_priceDup setFont:[UIFont systemFontOfSize:fonts]];
    }
    return _priceDup;
}
@end





