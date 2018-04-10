//
//  EDJMicroPSCellHeader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPSCellHeader.h"

@interface EDJMicroPSCellHeaderLeftRect : UIView

@end

@implementation EDJMicroPSCellHeaderLeftRect

- (void)setupUI{
    UIColor *color = [UIColor EDJMainColor];
    UIView *line = [UIView new];
    line.backgroundColor = color;
    [self addSubview:line];
    
    UIView *rect = [UIView new];
    rect.backgroundColor = color;
    [self addSubview:rect];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width).multipliedBy(0.9);
        make.height.mas_equalTo(1);
    }];
    
    [rect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(2);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
        make.width.mas_equalTo(2);
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
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

@end


@interface EDJMicroPSCellHeader ()
@property (strong,nonatomic) UILabel *title;

@end

@implementation EDJMicroPSCellHeader

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    [_title setText:titleText];
}

- (UILabel *)title{
    if (_title == nil) {
        _title = [UILabel new];
        _title.textColor = [UIColor EDJMainColor];
        _title.font = [UIFont systemFontOfSize:15];
        _title.text = @"习近平总书记系列原生讲话";
    }
    return _title;
}

- (void)setupUI{
    EDJMicroPSCellHeaderLeftRect *left = [EDJMicroPSCellHeaderLeftRect new];
    [self addSubview:left];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(8);
        make.right.equalTo(self.title.mas_left).offset(-marginTen);
    }];
    
    EDJMicroPSCellHeaderLeftRect *right = [EDJMicroPSCellHeaderLeftRect new];
    [self addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(left.mas_width);
        make.height.equalTo(left.mas_height);
        make.left.equalTo(self.title.mas_right).offset(marginTen);
    }];
    right.transform = CGAffineTransformMakeRotation(M_PI);
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
    [self setupUI];
}

@end
