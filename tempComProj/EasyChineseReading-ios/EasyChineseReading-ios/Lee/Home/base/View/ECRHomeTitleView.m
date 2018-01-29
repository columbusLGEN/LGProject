//
//  ECRHomeTitleView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//
static CGFloat cnFont = 16;
static CGFloat marginA = 10;
static NSString *doneArrowImgName = @"icon_arrow_down";
static NSString *searchBtnTitle = @"searchbookauthor";
static NSString *searchIconName = @"icon_search";
static NSString *searchTxtColor = @"f7f7f7";
static NSString *cartIconName = @"icon_shop_car_white";
//static NSString *defaultLocText = @"中国";

#import "ECRHomeTitleView.h"
#import "UIView+Extension.h"
#import "ECRSearchBar.h"
#import "LGCartIcon.h"

@interface ECRHomeTitleView ()

@property (strong,nonatomic) UIImageView *navBg;//
// 定位按钮
@property (strong,nonatomic) UIImageView *downArrow;//
@property (strong,nonatomic) UIButton *locatioButton;//
// 1.搜索按钮
@property (strong,nonatomic) UIButton *fakeSearch;
/** 导航栏颜色 */
@property (strong,nonatomic) UIColor *navBgColor;

@end

@implementation ECRHomeTitleView

- (UIColor *)navBgColor{
    if (_navBgColor == nil) {
        _navBgColor = [LGSkinSwitchManager currentThemeColor];
    }
    return _navBgColor;
}

- (void)setBgdsState:(ECRHomeTitleViewBgdsState)bgdsState{
    _bgdsState = bgdsState;
    switch (bgdsState) {
        case ECRHomeTitleViewBgdsStateDefault:{
            self.backgroundColor = [UIColor clearColor];
            self.navBg.hidden = NO;
        }
            break;
        case ECRHomeTitleViewBgdsStateSolid:{
            self.backgroundColor = self.navBgColor;// [UIColor cm_purpleColor_82056B_1];
            self.navBg.hidden = YES;
        }
            break;
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if (title == nil) {
        _title = self.defaultLocText;
    }
    if (title == nil) {
        self.contryName.text = self.defaultLocText;
    }else{
        self.contryName.text = [self displayCountryName:title];
    }
}

- (void)textDependsLauguage{
    [self.fakeSearch setTitle:[LGPChangeLanguage localizedStringForKey:searchBtnTitle] forState:UIControlStateNormal];
}

// 点击定位
- (void)locationClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(htViewRgLocated:cnBlock:)]) {
        [self.delegate htViewRgLocated:self cnBlock:^(NSString *country) {
            country = [self displayCountryName:country];
            self.contryName.text = country;
        }];
    }
}
// 点击搜索
- (void)searchClick:(UIButton *)bsender{
    if ([self.delegate respondsToSelector:@selector(htViewBeginSearch:)]) {
        [self.delegate htViewBeginSearch:self];
    }
}

// 点击购物车按钮
- (void)scClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(htView:sCarClick:)]) {
        [self.delegate htView:self sCarClick:nil];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.navBg];
        [self addSubview:self.contryName];
        [self addSubview:self.downArrow];
        [self addSubview:self.locatioButton];
        [self addSubview:self.fakeSearch];
        [self addSubview:self.cartButton];
        
        [self.navBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
        
        [self.contryName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(marginA);
//            make.centerY.equalTo(self.mas_centerY).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
            make.width.equalTo(@40);
        }];
        [self.downArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contryName.mas_right).offset(-2);
            make.centerY.equalTo(self.contryName.mas_centerY);
        }];
        [self.locatioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contryName.mas_top);
            make.left.equalTo(self.contryName.mas_left);
            make.bottom.equalTo(self.contryName.mas_bottom);
            make.right.equalTo(self.downArrow.mas_right);
        }];
        
        [self.fakeSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.downArrow.mas_right).offset(4);
            make.centerY.equalTo(self.contryName.mas_centerY);
            make.height.equalTo(@30);
        }];

        /// shoppingCar
        [self.cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fakeSearch.mas_right).offset(8);
            make.right.equalTo(self.mas_right).offset(-marginA);
            make.centerY.equalTo(self.fakeSearch.mas_centerY);
            make.width.equalTo(@(30));
        }];

        [self textDependsLauguage];
        self.contryName.textColor = [UIColor whiteColor];
        self.contryName.text = self.defaultLocText;
        [self.downArrow setImage:[UIImage imageNamed:@"icon_arrow_down_white"]];

        [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
    }
    return self;
}
- (void)skinWithType:(ECRHomeUIType)type{
//    NSString *cartIconImgName;
//    switch (type) {
//        case ECRHomeUITypeDefault:{
//        }
//        case ECRHomeUITypeAdultTwo:{
//            cartIconImgName = cartIconName;
//        }
//            break;
//        case ECRHomeUITypeKidOne:{
//        }
//            break;
//        case ECRHomeUITypeKidtwo:{
//        }
//            break;
//    }
    self.cartButton.iconImgName = cartIconName;
    self.navBgColor = [UIColor cm_mainColor];
}
- (UIImageView *)navBg{
    if (_navBg == nil) {
        _navBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_nav_bg"]];
        _navBg.contentMode = UIViewContentModeScaleAspectFill;
        _navBg.clipsToBounds = YES;
    }
    return _navBg;
}
- (UILabel *)contryName{
    if (_contryName == nil) {
        _contryName = [[UILabel alloc] init];
        _contryName.font = [UIFont systemFontOfSize:cnFont];
    }
    return _contryName;
}
- (UIImageView *)downArrow{
    if (_downArrow == nil) {
        _downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:doneArrowImgName]];
    }
    return _downArrow;
}
- (UIButton *)locatioButton{
    if (_locatioButton == nil) {
        _locatioButton = [[UIButton alloc] init];
        [_locatioButton addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locatioButton;
}
- (UIButton *)fakeSearch{
    if (_fakeSearch == nil) {
        _fakeSearch = [[UIButton alloc] init];
        _fakeSearch.highlighted = NO;
        _fakeSearch.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fakeSearch setTitleColor:[UIColor cm_blackColor_333333_1] forState:UIControlStateNormal];
        [_fakeSearch setImage:[UIImage imageNamed:searchIconName] forState:UIControlStateNormal];
        [_fakeSearch setBackgroundColor:[UIColor colorWithHexString:searchTxtColor]];
        _fakeSearch.layer.cornerRadius = 16;
        _fakeSearch.layer.masksToBounds = YES;
        [_fakeSearch setContentEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
        [_fakeSearch addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fakeSearch;
}
- (LGCartIcon *)cartButton{
    if (_cartButton == nil) {
        _cartButton = [LGCartIcon new];
        [_cartButton.button addTarget:self action:@selector(scClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartButton;
}
//- (UIButton *)shoppingCar{
//    if (_shoppingCar == nil) {
//        _shoppingCar = [[UIButton alloc] init];
//        [_shoppingCar setBackgroundImage:[UIImage imageNamed:cartIconName] forState:UIControlStateNormal];
//        [_shoppingCar sizeToFit];
//        [_shoppingCar addTarget:self action:@selector(scClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _shoppingCar;
//}
- (NSString *)defaultLocText{
    return [LGPChangeLanguage localizedStringForKey:@"中国"];
}
- (NSString *)displayCountryName:(NSString *)country{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        if ([country isEqualToString:@"中国"]) {
            country = @"China";
        }
    }
    return country;
}

@end



