//
//  LGAudioPlayerView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGAudioPlayerView.h"

static CGFloat progressHeight = 5;

@interface LGAudioPlayerView ()


@end

@implementation LGAudioPlayerView

- (void)configUI{
    [self addSubview:self.play];
    [self addSubview:self.progress];
    [self addSubview:self.currentTime];
    [self addSubview:self.totalTime];
    
    [self.play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(9);
        make.left.equalTo(self.mas_left).offset(9);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.play.mas_centerY);
        make.left.equalTo(self.play.mas_right).offset(marginTen);
        make.right.equalTo(self.mas_right).offset(-marginTen);
        make.height.mas_equalTo(progressHeight);
    }];
    [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progress.mas_left);
        make.top.equalTo(self.progress.mas_bottom).offset(marginTen);
    }];
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progress.mas_right);
        make.centerY.equalTo(self.currentTime.mas_centerY);
    }];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (UIButton *)play{
    if (!_play) {
        UIButton *play = [UIButton new];
        [play setImage:[UIImage imageNamed:@"dc_stage_audio_play"] forState:UIControlStateNormal];
        [play setImage:[UIImage imageNamed:@"home_audio_resume"] forState:UIControlStateSelected];
        
        _play = play;
    }
    return _play;
}
- (UIProgressView *)progress{
    if (!_progress) {
        UIProgressView *progress = [UIProgressView new];
        progress.tintColor = [UIColor EDJMainColor];
        progress.progress = 0.7;
        _progress = progress;
    }
    return _progress;
}
- (UILabel *)currentTime{
    if (!_currentTime) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor EDJGrayscale_11];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"00 : 00";
        
        _currentTime = label;
    }
    return _currentTime;
}
- (UILabel *)totalTime{
    if (!_totalTime) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor EDJGrayscale_11];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"00 : 00";
        _totalTime = label;
        
    }
    return _totalTime;
}

@end
