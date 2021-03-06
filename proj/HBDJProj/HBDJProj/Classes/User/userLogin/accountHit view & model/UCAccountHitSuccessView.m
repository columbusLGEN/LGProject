//
//  UCAccountHitSuccessView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCAccountHitSuccessView.h"

@interface UCAccountHitSuccessView ()
@property (strong,nonatomic) UIButton *bgButton;
@property (strong,nonatomic) UIImageView *img;
@property (strong,nonatomic) UILabel *info;

@property (weak,nonatomic) NSTimer *timer;

@end

@implementation UCAccountHitSuccessView

- (void)bgClick{
    [_timer invalidate];
    if ([self.delegate respondsToSelector:@selector(removehsView)]) {
        [self.delegate removehsView];
    }
    [self removeFromSuperview];
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgButton];
    [self addSubview:self.img];
    [self addSubview:self.info];
    
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.img.mas_bottom).offset(marginTen);
    }];
    
    __block NSInteger second = 3;
    
    __weak typeof(self) weakSelf = self;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.info.text = [NSString stringWithFormat:@"正在返回登陆页面 %lds",second];
        second--;
        if (second == -1) {
            [timer invalidate];
            strongSelf.timer = nil;
            [strongSelf removeFromSuperview];
            if ([strongSelf.delegate respondsToSelector:@selector(removehsView)]) {
                [strongSelf.delegate removehsView];
            }
        }
    }];
    [timer fire];
    _timer = timer;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (UIButton *)bgButton{
    if (!_bgButton) {
        _bgButton = [UIButton new];
        [_bgButton setBackgroundColor:[UIColor blackColor]];
        [_bgButton addTarget:self action:@selector(bgClick) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.alpha = 0.6;
    }
    return _bgButton;
}
- (UIImageView *)img{
    if (!_img) {
        _img = [UIImageView new];
        _img.image = [UIImage imageNamed:@"uc_ah_success_mid_img"];
//        _img.backgroundColor = [UIColor randomColor];
    }
    return _img;
}
- (UILabel *)info{
    if (!_info) {
        _info = [UILabel new];
        _info.textColor = [UIColor whiteColor];
        _info.font = [UIFont systemFontOfSize:14];
        _info.text = @"正在返回登陆页面 3s";
    }
    return _info;
}

- (void)dealloc{
    NSLog(@"dealloc_timer: %@",_timer);
}

@end
