//
//  ECRHeadlineView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/20.
//  Copyright © 2017年 retech. All rights reserved.
//

static CGFloat margin = 14;
static CGFloat marginB = 10;
static CGFloat marginC = 8;
static NSString *moreIconName = @"icon_arrow_right_bookstore";
static CGFloat iconWH = 30;

#import "ECRHeadlineView.h"

@interface ECRHeadlineView ()
/** 图标 */
@property (strong,nonatomic) UIImageView *icon;
/** 标题 */
@property (strong,nonatomic) UIButton *title;
/** 标题背景图,有时显示 */
@property (strong,nonatomic) UIImageView *titleBg;
/** 标题后面的线 */
@property (strong,nonatomic) UIView *line;
@property (assign,nonatomic) CGFloat titleFont;//

@end

@implementation ECRHeadlineView

- (void)setIconImgName:(NSString *)iconImgName{
    _iconImgName = iconImgName;
    [self.icon setImage:[UIImage imageNamed:iconImgName]];
}

- (void)setShowMore:(BOOL)showMore{
    _showMore = showMore;
    if (showMore) {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.title.mas_centerY);
            make.left.equalTo(self.title.mas_right).offset(marginC);
            make.height.equalTo(@1);
            make.right.equalTo(self.more.mas_left).offset(-marginB);
        }];
        [self.more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.title.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-margin);
        }];
    }
}

- (void)textDependsLauguage{
    [self.title setTitle:[LGPChangeLanguage localizedStringForKey:_headTitle] forState:UIControlStateNormal];
    
}

- (void)setHeadTitle:(NSString *)headTitle{
    _headTitle = headTitle;
    [self textDependsLauguage];
}

- (void)setupUI{
    [self addSubview:self.icon];
    [self addSubview:self.titleBg];
    [self addSubview:self.title];
    [self addSubview:self.line];
    [self addSubview:self.more];
    
    [self.title setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    self.title.titleLabel.font = [UIFont systemFontOfSize:self.titleFont];

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.title.mas_centerY);
        make.height.equalTo(@(iconWH));
        make.width.equalTo(@(iconWH));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.icon.mas_right).offset(3);
    }];
    [self.titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_left);
        make.centerY.equalTo(self.title.mas_centerY);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title.mas_centerY);
        make.left.equalTo(self.title.mas_right).offset(marginB);
        make.right.equalTo(self.mas_right).offset(-margin);
        make.height.equalTo(@1);
    }];
    [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
}

- (void)titleLineWithThemeColor:(UIColor *)color{
    self.titleBg.hidden = YES;
    self.line.hidden = NO;
    self.line.backgroundColor = color;
    [self.title setTitleColor:color forState:UIControlStateNormal];
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.icon.mas_right).offset(3);
    }];
}
- (void)skinWithType:(ECRHomeUIType)type{
    switch (type) {
        case ECRHomeUITypeDefault:{/// 故意穿透此case
            self.backgroundColor = [UIColor whiteColor];
            [self titleLineWithThemeColor:[LGSkinSwitchManager currentThemeColor]];
        }
            break;
        case ECRHomeUITypeAdultTwo:{
            self.backgroundColor = [UIColor clearColor];
            [self titleLineWithThemeColor:[LGSkinSwitchManager currentThemeColor]];
        }
            break;
        case ECRHomeUITypeKidOne:{
            self.backgroundColor = [UIColor clearColor];
            self.titleBg.hidden = NO;
            self.line.hidden = YES;
            [self.titleBg setImage:[UIImage imageNamed:@"icon_hoem_headline_titlebg"]];
            [self.title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.titleBg.mas_centerX);
                make.centerY.equalTo(self.titleBg.mas_centerY).offset(-3);
            }];
            [self.titleBg mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top);
                make.left.equalTo(self.icon.mas_right).offset(3);
            }];
            
        }
            break;
        case ECRHomeUITypeKidtwo:{
            
        }
            break;
    }
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
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}
- (UIButton *)title{
    if (_title == nil) {
        _title = [[UIButton alloc] init];
    }
    return _title;
}
- (UIImageView *)titleBg{
    if (_titleBg == nil) {
        _titleBg = [UIImageView new];
    }
    return _titleBg;
}
- (UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc] init];
    }
    return _line;
}
- (UIButton *)more{
    if (_more == nil) {
        _more = [[UIButton alloc] init];
//        icon_arrow_right_bookstore
        [_more setBackgroundImage:[UIImage imageNamed:moreIconName] forState:UIControlStateNormal];

    }
    return _more;
}

- (CGFloat)titleFont{
    if (Screen_Width > 414) {
        return 18;
    }else{
        return 16;
    }
}

@end
