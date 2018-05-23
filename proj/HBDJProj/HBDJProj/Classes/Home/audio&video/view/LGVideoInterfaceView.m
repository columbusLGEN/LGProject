//
//  LGVideoInterfaceView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGVideoInterfaceView.h"

@interface LGVideoInterfaceView ()
@property (strong,nonatomic) UILabel *currentTime;
@property (strong,nonatomic) UIProgressView *progress;
@property (strong,nonatomic) UILabel *totalTime;
@property (strong,nonatomic) UIButton *allScreen;

@end

@implementation LGVideoInterfaceView

- (void)setupUI{
    [self addSubview:self.currentTime];
    [self addSubview:self.totalTime];
    [self addSubview:self.progress];
    [self addSubview:self.allScreen];
    
    [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginTen);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTime.mas_right).offset(marginFive);
        make.width.mas_equalTo(kScreenWidth * 0.55);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.progress.mas_right).offset(marginFive);
    }];
    [self.allScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-marginTen);
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
- (UILabel *)currentTime{
    if (!_currentTime) {
        _currentTime = [UILabel new];
        _currentTime.textColor = [UIColor whiteColor];
        _currentTime.font = [UIFont systemFontOfSize:15];
        _currentTime.text = @"00 : 00";
    }
    return _currentTime;
}
- (UILabel *)totalTime{
    if (!_totalTime) {
        _totalTime = [UILabel new];
        _totalTime.textColor = [UIColor whiteColor];
        _totalTime.font = [UIFont systemFontOfSize:15];
        _totalTime.text = @"05 : 00";
    }
    return _totalTime;
}
- (UIProgressView *)progress{
    if (!_progress) {
        _progress = [UIProgressView new];
        _progress.tintColor = [UIColor whiteColor];
        _progress.progress = 0.7;
        
    }
    return _progress;
}
- (UIButton *)allScreen{
    if (!_allScreen) {
        _allScreen = [UIButton new];
        [_allScreen setImage:[UIImage imageNamed:@"home_video_inte_all_screen"] forState:UIControlStateNormal];
    }
    return _allScreen;
}

@end
