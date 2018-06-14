//
//  LGPlayer.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGPlayer.h"

@interface LGPlayer ()<
PLPlayerDelegate>
@property (strong,nonatomic) PLPlayer *audioPlayer;
@property (strong,nonatomic) NSTimer *playTimer;

@end

@implementation LGPlayer

#pragma mark - PLPlayerDelegate
- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if (state == 10 || state == 8) {
        [self removeTimer];
    }
    NSInteger lg_state = state;
    NSLog(@"lg_state状态回调: %ld",lg_state);
    if ([self.delegate respondsToSelector:@selector(playerStateChanged:state:)]) {
        [self.delegate playerStateChanged:self state:lg_state];
    }
}

- (void)seekToProgress:(float)progress{
    float totalTime = CMTimeGetSeconds(self.audioPlayer.totalDuration);
    float destiTime = progress * totalTime;
    [self.audioPlayer seekTo:CMTimeMake(destiTime * 1000, 1000)];
}

/// MARK: timer相关,获取播放进度
- (void)addTimer{
    [self removeTimer];
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}
- (void)removeTimer{
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}
- (void)timerAction{
    float currentTime = CMTimeGetSeconds(self.audioPlayer.currentTime);
    float totalTime = CMTimeGetSeconds(self.audioPlayer.totalDuration);
    
    float floorfCurrentTime = floorf(currentTime);
    float floorfTotalTime = floorf(totalTime);
    
    if (floorfCurrentTime == floorfTotalTime) {
        [self removeTimer];
    }
    
    float progress = floorfCurrentTime / floorfTotalTime;
    if ([self.delegate respondsToSelector:@selector(playProgress:
                                                    progress:
                                                    currentTime:
                                                    totalTime:)]) {
        [self.delegate playProgress:self
                           progress:progress
                        currentTime:floorfCurrentTime
                          totalTime:floorfTotalTime];
    }
}


- (BOOL)lg_playWithUrl:(NSString *)url{
    self.audioPlayer = [[PLPlayer alloc] initWithURL:[NSURL URLWithString:url] option:nil];
    self.audioPlayer.delegate = self;
    [self addTimer];
    return [self.audioPlayer play];
}
- (void)lg_pause{
    /// 记录当前进度
    [self.audioPlayer pause];
}
- (void)lg_resume{
    [self.audioPlayer resume];
}
- (void)lg_stop_play{
    [self removeTimer];
    [self.audioPlayer stop];
}


@end
