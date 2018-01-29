//
//  ECRBookSortButtonView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBookSortButtonView.h"

@interface ECRBookSortButtonView ()
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UIButton *btn;
//@property (assign,nonatomic) CGAffineTransform imgOriTransform;//
@property (assign,nonatomic) BOOL isDesOrder;// 是否降序(由高到低)1是,0否

@end

@implementation ECRBookSortButtonView

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    [self setStatusWith:selected];
    _btn.selected = selected;
}

- (void)btnClick:(UIButton *)sender {
    if (sender.selected) {
        if (self.isDesOrder) {
            self.isDesOrder = NO;
            _img.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            self.isDesOrder = YES;
            _img.transform = CGAffineTransformMakeRotation(0);
        }
//        if (CGAffineTransformEqualToTransform(_img.transform, self.imgOriTransform)) {
//            _img.transform = CGAffineTransformMakeRotation(M_PI);
//        }else{
//            _img.transform = CGAffineTransformMakeRotation(0);
//        }
    }else{
        sender.selected = YES;
        
    }
    [self setStatusWith:sender.selected];
    if ([self.delegate respondsToSelector:@selector(bsbView:selected:)]) {
        [self.delegate bsbView:self selected:sender.selected];
    }
    if ([self.delegate respondsToSelector:@selector(bsbView:isDesOrder:)]) {
        [self.delegate bsbView:self isDesOrder:self.isDesOrder];
    }
}

- (void)setStatusWith:(BOOL)selected{
    if (selected) {
        // 选中状态
        [_title setTextColor:[LGSkinSwitchManager currentThemeColor]];
        [_img setImage:[UIImage imageNamed:@"icon_favourite_arrow_down"]];
        
    }else{
        // 普通状态
        [_title setTextColor:[UIColor cm_blackColor_666666_1]];
        [_img setImage:[UIImage imageNamed:@"icon_favourite_arrow_down_gray"]];
    }
}

- (void)setName:(NSString *)name{
    _name = name;
    [self.title setText:name];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.title];
    [self addSubview:self.img];
    [self addSubview:self.btn];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
//    self.imgOriTransform = self.img.transform;
    self.isDesOrder = YES;
}
- (UILabel *)title{
    if (_title == nil) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = [UIColor cm_blackColor_666666_1];
    }
    return _title;
}
- (UIImageView *)img{
    if (_img == nil) {
        _img = [[UIImageView alloc] init];
        [_img setImage:[UIImage imageNamed:@"icon_favourite_arrow_down_gray"]];
    }
    return _img;
}
- (UIButton *)btn{
    if (_btn == nil) {
        _btn = [[UIButton alloc] init];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end









