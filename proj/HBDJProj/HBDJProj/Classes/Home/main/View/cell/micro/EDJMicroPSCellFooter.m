//
//  EDJMicroPSCellBottom.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPSCellFooter.h"

@interface EDJMicroPSCellFooter ()


@end


@implementation EDJMicroPSCellFooter

- (void)setupUI{
//    self.userInteractionEnabled = YES;
    UIColor *lineColor = [UIColor EDJGrayscale_EC];
    UIView *line_left = [UIView new];
    line_left.backgroundColor = lineColor;
    [self addSubview:line_left];
    UIView *line_right = [UIView new];
    line_right.backgroundColor = lineColor;
    [self addSubview:line_right];
    
    UIImageView *icon = [UIImageView new];
    [icon setImage:[UIImage imageNamed:@"home_icon_micro_goto_album"]];
    [self addSubview:icon];
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"进入专辑";
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-5);
    }];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_left).offset(-marginFive);
    }];
    CGFloat lineWidth = 30;
    CGFloat lineHeight = 1;
    [line_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(icon.mas_left).offset(-marginEight);
        make.centerY.equalTo(label.mas_centerY);
        make.height.mas_equalTo(lineHeight);
        make.width.mas_equalTo(lineWidth);
    }];
    [line_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(marginEight);
        make.centerY.equalTo(label.mas_centerY);
        make.height.mas_equalTo(lineHeight);
        make.width.mas_equalTo(lineWidth);
    }];
    
    UIView *line_sep = [[UIView alloc] init];
    line_sep.backgroundColor = [UIColor EDJGrayscale_F6];
    [self addSubview:line_sep];
    [line_sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
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
