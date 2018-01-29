//
//  ECRBookrackEditBottom.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/26.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookrackEditBottom.h"

@interface ECRBookrackEditBottom ()
@property (strong,nonatomic) UIView *line;// <##>
@property (strong,nonatomic) UIImageView *icon;//
@property (strong,nonatomic) UIButton *deleteBtn;//

@end

@implementation ECRBookrackEditBottom

- (void)bottomDelete:(UIButton *)sender{
    // 点击删除
    if ([self.delegate respondsToSelector:@selector(brebDeleteClick:)]) {
        [self.delegate brebDeleteClick:self];
    }
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.line];
    [self addSubview:self.icon];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(self.width));
        make.height.equalTo(@(self.height));
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@1);
        make.width.equalTo(@(self.width));
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
- (UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    }
    return _line;
}
- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn addTarget:self action:@selector(bottomDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_trash_bookrack_purple"]];
    }
    return _icon;
}

@end
