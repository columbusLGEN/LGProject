//
//  EDJMicroLessonHeaderView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroLessonHeaderView.h"
#import "LGImageView.h"

@interface EDJMicroLessonHeaderView ()
@property (strong,nonatomic) LGImageView *leftImg;
@property (strong,nonatomic) LGImageView *rightImg;
@property (strong,nonatomic) UIButton *leftButton;
@property (strong,nonatomic) UIButton *rightButton;

@end

@implementation EDJMicroLessonHeaderView

- (void)buttonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(mlHeaderClick:segment:)]) {
        [self.delegate mlHeaderClick:self segment:sender.tag];
    }
}

- (LGImageView *)leftImg{
    if (_leftImg == nil) {
        _leftImg = [LGImageView new];
        _leftImg.image = [UIImage imageNamed:@"party_history"];
    }
    return _leftImg;
}
- (LGImageView *)rightImg{
    if (_rightImg == nil) {
        _rightImg = [LGImageView new];
        _rightImg.image = [UIImage imageNamed:@"party_history"];
    }
    return _rightImg;
}
- (UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [UIButton new];
        _leftButton.tag = 1;
        [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [UIButton new];
        _rightButton.tag = 2;
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    /// 根据比例remake约束,根据不同屏幕,适配高度
    [self.leftImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginTen);
        make.top.equalTo(self.mas_top).offset(marginTwelve);
        make.right.equalTo(self.rightImg.mas_left).offset(-25);
        /// 在已经计算出width的情况下,根据16/9的比例算出高度
        make.height.mas_equalTo(self.leftImg.width * 9 / 16);
        //        make.width.mas_equalTo((kScreenWidth - 45)/2);
    }];
    [self.rightImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImg.mas_top);
        make.right.equalTo(self.mas_right).offset(-marginTen);
        make.width.equalTo(self.leftImg.mas_width);
        make.height.equalTo(self.leftImg.mas_height);
    }];
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftImg];
    [self addSubview:self.rightImg];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginTen);
        make.top.equalTo(self.mas_top).offset(marginTwelve);
        make.right.equalTo(self.rightImg.mas_left).offset(-25);
        make.bottom.equalTo(self.mas_bottom).offset(-marginTwelve);
//        make.width.mas_equalTo((kScreenWidth - 45)/2);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImg.mas_top);
        make.right.equalTo(self.mas_right).offset(-marginTen);
        make.width.equalTo(self.leftImg.mas_width);
        make.height.equalTo(self.leftImg.mas_height);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImg.mas_top);
        make.left.equalTo(self.leftImg.mas_left);
        make.right.equalTo(self.leftImg.mas_right);
        make.bottom.equalTo(self.leftImg.mas_bottom);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightImg.mas_top);
        make.left.equalTo(self.rightImg.mas_left);
        make.right.equalTo(self.rightImg.mas_right);
        make.bottom.equalTo(self.rightImg.mas_bottom);
    }];
}

+ (instancetype)mlHeaderViewWithDelegate:(id<EDJMicroLessonHeaderViewDelegate>) delegat frame:(CGRect)frame{
    return [[self alloc] mlHeaderViewWithDelegate:delegat frame:frame];
}
- (instancetype)mlHeaderViewWithDelegate:(id<EDJMicroLessonHeaderViewDelegate>) delegat frame:(CGRect)frame{
    EDJMicroLessonHeaderView *header = [[EDJMicroLessonHeaderView alloc] initWithFrame:frame];
    header.delegate = delegat;
    return header;
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
