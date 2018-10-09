//
//  LGAudioPlayerManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGAudioPlayerManager.h"
#import "PLAudioPlayer.h"/// 音频播放

@interface LGAudioPlayerManager ()


@end

@implementation LGAudioPlayerManager{
    PLAudioPlayer *audioPlayer;
    LGAudioPlayerView *audioPlayerView;
    BOOL played;
    NSTimer *timer;
    NSInteger curTime;/// 当前时间
    CGFloat progress;/// 进度
}

- (void)setAudioTotalTime:(NSInteger)audioTotalTime{
    _audioTotalTime = audioTotalTime;
    audioPlayerView.tTime = audioTotalTime;
}

- (void)startPlay{
/// 开始播放
//    [audioPlayer startPlayAudioFile:[PLAudioPath recordPathOriginToAMR]
    [audioPlayer startPlayAudioFile:[PLAudioPath recordPathOrigin]
                       updateMeters:^(float meters){
//                           [self updateVolumeUI:meters];
                       }
                            success:^{
                                // 停止UI的播放
                                //
                                NSLog(@"结束播放");
                                audioPlayerView.play.selected = NO;
                                played = NO;

                            } failed:^(NSError *error) {
                                // 停止UI的播放
                                NSLog(@"结束播放 failed");
                                audioPlayerView.play.selected = NO;
                                audioPlayerView.progressValue = 0;
                                played = NO;
                                
                            } ];

}

- (void)stopPlay{
    [audioPlayer stopPlay];
}

- (void)timerLoop{
    curTime += 1;
    progress = (CGFloat) curTime / self.audioTotalTime;
    if (curTime == self.audioTotalTime) {
        progress = 1;
        [timer invalidate];
        timer = nil;
        played = NO;
    }
    audioPlayerView.progressValue = progress;
    audioPlayerView.cTime = curTime;
}

/// 开始播放
- (void)audioPlayerViewPlay:(UIButton *)sender{
    if (sender.isSelected) {
        /// 暂停
        /// 暂停计时
        [timer setFireDate:[NSDate distantFuture]];
        [audioPlayer pause];
    }else{
        if (!played) {
            /// 首次播放
            /// 开始计时
            
            [self startPlay];
            curTime = 0;
            audioPlayerView.progressValue = 0;
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];
            [timer fire];
            
        }else{
            /// 继续
            /// 继续计时
            [timer setFireDate:[NSDate date]];
            [audioPlayer resume];
        }
    }
    sender.selected = !sender.isSelected;
    played = YES;
}

//- (void)a{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"mm:ss"];
//    NSString *currentString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:curTime]];
//
//    NSString *totalString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_audioTotalTime]];
//
//    audioPlayerView.totalTime.text = totalString;
//    audioPlayerView.currentTime.text = currentString;
//
//}

/// 返回 playerview的方法
- (LGAudioPlayerView *)audioPlayerView{
    return audioPlayerView;
}

- (instancetype)init{
    if (self = [super init]) {

        curTime = 0;

        audioPlayer = [[PLAudioPlayer alloc] init];
        /**
         *  是否需要转码的逻辑判断，默认为NO
         当为NO是录制的格式是默认的wav格式，这种格式iOS是支持的；
         因为iOS支持的格式基本android都不支持，android支持的iOS全部都不支持，但是为了实现与android平台的IM互通，所以把iOS支持的wav转为android支持的amr
         所以这里可以设置isNeedConvert为yes，表示在播放之前，会把amr格式的转换为wav格式
         */
        audioPlayer.isNeedConvert=YES;
        
        audioPlayerView = LGAudioPlayerView.new;
        audioPlayerView.progressValue = 0;
        played = NO;
        [audioPlayerView.play addTarget:self action:@selector(audioPlayerViewPlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc{
    [timer invalidate];
    timer = nil;
}

@end
