//
//  HPAudioPlayerView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAudioPlayerView.h"
#import "LGAudioPlayerView.h"
#import "DJDataBaseModel.h"

#import "LGGaussManager.h"
#import "LGPlayer.h"

#import "DJLessonDetailViewController.h"

@interface HPAudioPlayerView ()<
LGPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *iconBg;
@property (strong,nonatomic) LGPlayer *audio;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

/** if (played == YES),不是首次播放*/
@property (assign,nonatomic) BOOL played;
/** YES: 总时间已经设置过 */
@property (assign,nonatomic) BOOL totalTimeSet;

@end

@implementation HPAudioPlayerView

- (void)audioStop{
    [_audio lg_stop_play];
}

#pragma mark - LGPlayerDelegate
- (void)playProgress:(LGPlayer *)player progress:(float)progress currentTime:(float)currentTime totalTime:(float)totalTime{
    
//    if (currentTime < 0) {
//        currentTime = 0;
//    }
    self.audioPlayer.progressValue = progress;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *currentString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    
    NSString *totalString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:totalTime]];
    
    
    self.audioPlayer.currentTime.text = currentString;
    /// 总时间，只设置一次
    if (!_totalTimeSet) {
        self.audioPlayer.totalTime.text = totalString;
        _totalTimeSet = YES;
    }
//    NSLog(@"cutime: %f totaltime: %f",currentTime,totalTime);
}
- (void)playerStateChanged:(LGPlayer *)player state:(LGPlayerState)state{
    if (state == 10) {
        self.audioPlayer.progressValue = 1;
        _played = NO;
        _audioPlayer.play.selected = NO;
        
        if ([self.delegate respondsToSelector:@selector(currentMediaPlayCompleteWithCurrentModel:)]) {
            [self.delegate currentMediaPlayCompleteWithCurrentModel:self.model];
        }
    }
    
}

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    [_bgImg sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    [_audio initPlayerWithUrl:model.audio];
    
}

- (void)manualPlay{
    [self play:self.audioPlayer.play];
}

- (void)play:(UIButton *)sender{
    
    _lessonDetailVc.opreated = YES;
    if (sender.isSelected) {
        /// 暂停
        [_audio lg_pause];
    }else{
        
        if (!_played) {
            /// 首次播放
            [_audio lg_play];
            self.audioPlayer.progressValue = 0;
        }else{
            [_audio lg_resume];
        }
    }
    sender.selected = !sender.isSelected;
    _played = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    /// 高斯背景
    UIVisualEffectView *effectView = [LGGaussManager gaussViewWithFrame:_iconBg.bounds style:UIBlurEffectStyleLight];
    
    [_iconBg addSubview:effectView];
    [_iconBg bringSubviewToFront:_icon];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _audio = [LGPlayer new];
    _audio.delegate = self;
    _played = NO;
    
    self.audioPlayer.showCPB = YES;
    
    _audioPlayer.progressValue = 0;
    [_audioPlayer.play addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    [_icon cutBorderWithBorderWidth:0.5 borderColor:[UIColor whiteColor] cornerRadius:0];
    [_icon setShadowWithShadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.8 shadowRadius:15];
}

+ (instancetype)audioPlayerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPAudioPlayerView" owner:nil options:nil] lastObject];
}

- (void)dealloc{
    [_audio lg_stop_play];

}

@end
