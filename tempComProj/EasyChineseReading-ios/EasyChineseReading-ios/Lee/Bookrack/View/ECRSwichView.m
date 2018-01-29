//
//  ECRSwichView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

static CGFloat elfHeight = 3;

#import "ECRSwichView.h"

@interface ECRSwichView ()
// 分割线
@property (strong,nonatomic) UIView *lineTop;
@property (strong,nonatomic) UIView *lineBottom;

// 按钮
@property (strong,nonatomic) UIButton *buttonLeft;// 左
@property (strong,nonatomic) UIButton *buttonRight;// 右

// 下划线
@property (strong,nonatomic) UIView *underButton;



@end

@implementation ECRSwichView

- (void)setButtonNames:(NSArray<NSString *> *)buttonNames{
    _buttonNames = buttonNames;
    [_buttonNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [_buttonLeft setTitle:obj forState:UIControlStateNormal];
            [_buttonLeft setNeedsLayout];
            [_buttonLeft layoutIfNeeded];
            [_underButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(elfHeight));
                make.left.equalTo(_buttonLeft.titleLabel.mas_left);
//                make.top.equalTo(_buttonLeft.titleLabel.mas_bottom).offset(2);
                make.bottom.equalTo(self.lineBottom.mas_top);
                make.width.equalTo(@(_buttonLeft.titleLabel.width));
            }];
        }else{
            [_buttonRight setTitle:obj forState:UIControlStateNormal];
        }
        
    }];
    
}
- (void)switchSelectedItem:(NSInteger)item{
    switch (item) {
        case 0:{
            _buttonLeft.selected = YES;
            _buttonRight.selected = NO;
            [_underButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(elfHeight));
                make.left.equalTo(_buttonLeft.titleLabel.mas_left);
//                make.top.equalTo(_buttonLeft.titleLabel.mas_bottom).offset(2);
                make.bottom.equalTo(self.lineBottom.mas_top);
                make.width.equalTo(@(_buttonLeft.titleLabel.width));
            }];
        }
            break;
            
        case 1:{
            _buttonLeft.selected = NO;
            _buttonRight.selected = YES;
            [_underButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(elfHeight));
                make.left.equalTo(_buttonRight.titleLabel.mas_left);
//                make.top.equalTo(_buttonRight.titleLabel.mas_bottom).offset(2);
                make.bottom.equalTo(self.lineBottom.mas_top);
                make.width.equalTo(@(_buttonRight.titleLabel.width));
            }];
        }
            break;
    }
}

#pragma mark - target
- (void)btnClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(ecrSwichView:didClick:)]) {
        [self.delegate ecrSwichView:self didClick:sender.tag];
    }
    [self switchSelectedItem:sender.tag];

}


// 初始化
- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height{
    _customHeight = height;
    return [self initWithFrame:frame];
}

-  (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _customHeight = 0;
        [self setupSonUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSonUI];
    }
    return self;
}

- (void)setupSonUI{
    CGFloat btnFont = 16;// 字体大小
    CGFloat buttonHeight;// 按钮高度
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        buttonHeight = 44;
    }else{
        buttonHeight = 44;
    }
    
    if (_customHeight == 0) {
        
    }else{
        buttonHeight = _customHeight;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    UIColor *btnTextColorNormal = [UIColor colorWithHexString:@"666666"];
    UIColor *purple = [UIColor cm_mainColor];
    _lineTop = [[UIView alloc]init];
    _lineBottom = [[UIView alloc]init];
    _buttonLeft = [[UIButton alloc]init];
    _buttonLeft.selected = YES;// 默认选中图片详情
    _buttonLeft.tag = 0;
    [_buttonLeft setTitleColor:btnTextColorNormal forState:UIControlStateNormal];
    [_buttonLeft setTitleColor:purple forState:UIControlStateSelected];
    _buttonLeft.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    _buttonRight = [[UIButton alloc] init];
    _buttonRight.tag = 1;
    [_buttonRight setTitleColor:btnTextColorNormal forState:UIControlStateNormal];
    [_buttonRight setTitleColor:purple forState:UIControlStateSelected];
    _buttonRight.titleLabel.font = [UIFont systemFontOfSize:btnFont];
    _underButton = [[UIView alloc] init];

    UIColor *lineColor = [UIColor colorWithHexString:@"e3e3e3"];
    _lineTop.backgroundColor = lineColor;
    _lineBottom.backgroundColor = lineColor;
    _underButton.backgroundColor = purple;
    
    [self addSubview:_lineTop];
    [self addSubview:_lineBottom];
    [self addSubview:_buttonLeft];
    [self addSubview:_buttonRight];
    [self addSubview:_underButton];
    
    [_lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    [_lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [_buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineTop.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(_buttonRight.mas_left);
        make.width.equalTo(@(Screen_Width * 0.5));
        make.height.equalTo(@(buttonHeight));
    }];
    [_buttonRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineTop.mas_bottom);
        make.left.equalTo(_buttonLeft.mas_right);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@(Screen_Width * 0.5));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [_buttonLeft addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}


// lazy

@end
