//
//  LGAudioPlayerView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGAudioPlayerView.h"

static CGFloat progressHeight = 5;
static CGFloat progressRectWidth = 3;

@interface LGAudioPlayerView ()
@property (strong,nonatomic) UIProgressView *progress;
//@property (strong,nonatomic) UIView *rect;

@property (strong,nonatomic) UISlider *slider;

@end

@implementation LGAudioPlayerView

- (void)setShowCPB:(BOOL)showCPB{
    _showCPB = showCPB;
    
    if (showCPB) {
        [self addSubview:self.conPlay];
        [self.conPlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-marginTen);
            make.centerY.equalTo(self.play.mas_centerY);
            
        }];
        [self.progress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.play.mas_centerY);
            make.left.equalTo(self.play.mas_right).offset(marginTen);
            make.right.equalTo(self.conPlay.mas_left).offset(-marginEight);
            make.height.mas_equalTo(progressHeight);
        }];
        [self.totalTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.conPlay.mas_right);
            make.centerY.equalTo(self.currentTime.mas_centerY);
        }];
    }else{
        
    }
}

- (NSDateFormatter *)formatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    return formatter;
}

- (void)setTTime:(NSInteger)tTime{
    _tTime = tTime;
    NSString *totalString = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:tTime]];
    self.totalTime.text = totalString;
}
- (void)setCTime:(NSInteger)cTime{
    _cTime = cTime;
    NSString *currentString = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:cTime]];
    self.currentTime.text = currentString;
}

- (void)setProgressValue:(CGFloat)progressValue{
    _progressValue = progressValue;
    
//    _progress.progress = progressValue;

//    [UIView animateWithDuration:1.0 animations:^{
//        CGRect frame = _rect.frame;
        if (_progress.progress == 1) {
//            frame.origin.x = roundf(progressValue * _progress.width + _progress.x - progressRectWidth);
            self.play.selected = NO;
        }else{
//            frame.origin.x = roundf(progressValue * _progress.width + _progress.x);
        }
//        _rect.frame = frame;
//    }];
    
    [self.slider setValue:_progressValue animated:NO];
    [_progress setProgress:progressValue animated:NO];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.rect.backgroundColor = UIColor.EDJMainColor;
    [_progress cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_progress.height * 0.5];
}

- (void)configUI{
    [self addSubview:self.play];
    [self addSubview:self.progress];
    [self addSubview:self.currentTime];
    [self addSubview:self.totalTime];
    [self addSubview:self.slider];
    
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
        make.left.equalTo(self.play.mas_left).offset(marginFive);
        make.top.equalTo(self.progress.mas_bottom).offset(marginTen);
    }];
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progress.mas_right);
        make.centerY.equalTo(self.currentTime.mas_centerY);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progress);
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

/// MARK: 拖动进度条
- (void)cliderValueChanged:(UISlider *)sender{
    [_progress setProgress:sender.value animated:NO];
    if ([self.delegate respondsToSelector:@selector(avSliderValueChanged:slider:)]) {
        [self.delegate avSliderValueChanged:self slider:sender];
    }
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
        progress.progress = 0.0;
        progress.trackTintColor = [UIColor EDJGrayscale_F6];

        _progress = progress;
    }
    return _progress;
}
- (UISlider *)slider{
    if (!_slider) {
        _slider = UISlider.new;
        [_slider addTarget:self action:@selector(cliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.tintColor = UIColor.clearColor;
        _slider.backgroundColor = UIColor.clearColor;
        _slider.maximumTrackTintColor = UIColor.clearColor;
        
    }
    return _slider;
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
//- (UIView *)rect{
//    if (!_rect) {
//        _rect = [UIView.alloc initWithFrame:CGRectMake(_progress.x, _progress.y - 5, progressRectWidth, 15)];
//        [_rect cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:1.5];
////        [self addSubview:_rect];
//    }
//    return _rect;
//}
- (UIButton *)conPlay{
    if (!_conPlay) {
        _conPlay = UIButton.new;
        [_conPlay setImage:[UIImage imageNamed:@"con_play_audio"] forState:UIControlStateNormal];
        [_conPlay setImage:[UIImage imageNamed:@"con_play_highlighted"] forState:UIControlStateSelected];
    }
    return _conPlay;
}

@end
