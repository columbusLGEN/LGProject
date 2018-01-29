
//
//  ECRHomeTitleCountryNameView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/2.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRHomeTitleCountryNameView.h"

@interface ECRHomeTitleCountryNameView ()
@property (strong,nonatomic) UIButton *closeButton;//
@property (copy,nonatomic) NSString *countryName;//
@property (strong,nonatomic) UILabel *cnLabel;//
@property (strong,nonatomic) UIView *titleBg;//
@property (assign,nonatomic) CGRect titleFrame;//
@property (assign,nonatomic) CGRect titlebGFrame;//

@end

@implementation ECRHomeTitleCountryNameView

- (void)closeClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(htcnViewClose:)]) {
        [self.delegate htcnViewClose:self];
    }
}

- (instancetype)initWithCountryName:(NSString *)countryName frame:(CGRect)frame titleFrame:(CGRect)titleFrame{
    self.countryName = countryName;
    [self.cnLabel setText:countryName];
    [self.cnLabel sizeToFit];
    titleFrame.size.width = self.cnLabel.width;
    titleFrame.size.height = self.cnLabel.height;
//    NSLog(@"labelwidth -- %f",self.cnLabel.width);
//    NSLog(@"labelheight -- %f",self.cnLabel.height);
    self.titleFrame = titleFrame;
    
    CGRect titlebGFrame;
    titlebGFrame.origin.x = titleFrame.origin.x;
    titlebGFrame.origin.y = titleFrame.origin.y;
    titlebGFrame.size.width = titleFrame.size.width + 10;
    titlebGFrame.size.height = titleFrame.size.height + 8;
    self.titlebGFrame = titlebGFrame;
    
    return [self initWithFrame:frame];
}

- (void)setupUI{
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    
    [self addSubview:self.titleBg];
    [self.titleBg setFrame:self.titlebGFrame];
    [self.titleBg addSubview:self.cnLabel];
    [self.cnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleBg.mas_centerX);
        make.centerY.equalTo(self.titleBg.mas_centerY);
    }];
//    [self.cnLabel setFrame:self.titleFrame];
    
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
- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] init];
//        [_closeButton setBackgroundColor:[UIColor redColor]];
//        _closeButton.alpha = 0.5;
        [_closeButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UILabel *)cnLabel{
    if (_cnLabel == nil) {
        _cnLabel = [[UILabel alloc] init];
        _cnLabel.font = [UIFont systemFontOfSize:16];
        _cnLabel.textColor = [UIColor whiteColor];
    }
    return _cnLabel;
}
- (UIView *)titleBg{
    if (_titleBg == nil) {
        _titleBg = [[UIView alloc] init];
        _titleBg.backgroundColor = [UIColor colorWithRGB:0 alpha:0.7];
    }
    return _titleBg;
}


@end
