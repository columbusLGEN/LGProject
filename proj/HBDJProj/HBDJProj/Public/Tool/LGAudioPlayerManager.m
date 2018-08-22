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
                                NSLog(@"播放成功");



                            } failed:^(NSError *error) {
                                // 停止UI的播放


                            } ];

}

- (void)stopPlay{
    [audioPlayer stopPlay];
}

/// 开始播放
- (void)audioPlayerViewPlay:(UIButton *)sender{
    if (sender.isSelected) {
        sender.selected = NO;
        /// 暂停
        /// 暂停计时
        [timer setFireDate:[NSDate distantFuture]];
        [audioPlayer pause];
    }else{
        sender.selected = YES;
        if (!played) {
            /// 首次播放
            /// 开始计时
            
            [self startPlay];
            curTime = 0;
            audioPlayerView.progressValue = 0;
            
//            audioPlayerView.totalTime
            if (@available(iOS 10.0, *)) {
                __weak typeof(self) weakSelf = self;
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    curTime += 1;
                    progress = (CGFloat) curTime / strongSelf.audioTotalTime;
                    if (curTime == strongSelf.audioTotalTime) {
                        progress = 1;
                        [timer invalidate];
                        timer = nil;
                        played = NO;
                    }
                    audioPlayerView.progressValue = progress;
                    audioPlayerView.cTime = curTime;
                    
                }];
                [timer fire];
            } else {
                // Fallback on earlier versions
            }
        }else{
            /// 继续
            /// 继续计时
            [timer setFireDate:[NSDate date]];
            [audioPlayer resume];
        }
    }
    played = YES;
}

- (void)a{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *currentString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:curTime]];
    
    NSString *totalString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_audioTotalTime]];
    
    audioPlayerView.totalTime.text = totalString;
    audioPlayerView.currentTime.text = currentString;
    
}

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
