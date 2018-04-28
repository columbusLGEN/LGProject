//
//  LGThreeRightButtonView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGThreeRightButtonView.h"
#import "LGButton.h"

@interface LGThreeRightButtonView ()
@property (strong,nonatomic) UIView *line;
@property (strong, nonatomic) LGButton *leftBtn;
@property (strong, nonatomic) LGButton *midBtn;
@property (strong, nonatomic) LGButton *rightBtn;


@end

@implementation LGThreeRightButtonView

- (void)leftClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    
}
- (void)midClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}
- (void)rightClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}

- (void)setBtnConfigs:(NSArray<NSDictionary *> *)btnConfigs{
    _btnConfigs = btnConfigs;
    [btnConfigs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj[TRConfigTitleKey];
        NSString *imgName = obj[TRConfigImgNameKey];
        NSString *selectedImgName = obj[TRConfigSelectedImgNameKey];
        switch (idx) {
            case 0:{
                [_leftBtn setTitle:title forState:UIControlStateNormal];
                [_leftBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [_leftBtn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
            }
                break;
            case 1:{
                [_midBtn setTitle:title forState:UIControlStateNormal];
                [_midBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [_midBtn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
            }
                break;
            case 2:{
                [_rightBtn setTitle:title forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [_rightBtn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
            }
                break;
            
        }
    }];
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.line];
    [self addSubview:self.leftBtn];
    [self addSubview:self.midBtn];
    [self addSubview:self.rightBtn];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
    CGFloat buttonW = 60;
    CGFloat buttonH = 30;
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.midBtn.mas_left).offset(-marginEight);
        make.centerY.equalTo(self.rightBtn.mas_centerY);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(buttonH);
    }];
    [self.midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBtn.mas_left).offset(-marginEight);
        make.centerY.equalTo(self.rightBtn.mas_centerY);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(buttonH);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-marginFifteen);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(buttonH);
    }];
}
- (UIView *)line{
    if (_line == nil) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor EDJGrayscale_F3];
    }
    return _line;
}
- (LGButton *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [LGButton new];
        [_leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (LGButton *)midBtn{
    if (_midBtn == nil) {
        _midBtn = [LGButton new];
        [_midBtn addTarget:self action:@selector(midClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _midBtn;
}
- (LGButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [LGButton new];
        [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
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


@end
