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

- (void)initPlayerWithUrl:(NSString *)url{
    self.audioPlayer = [[PLPlayer alloc] initWithURL:[NSURL URLWithString:url] option:nil];
    self.audioPlayer.delegate = self;
    [self addTimer];
    /// 因为后台无法提供资源的时间数据，所以 为了获取到资源的总时间，在此先play，再pause。 虽然这种处理方法不是解决问题的方式，但是目前没有别的方法
    [self.audioPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.audioPlayer pause];
    });
    
}
- (void)lg_play{
    /// 因为在init中已经play了，所以play方法直接调用resume即可
//    return [self.audioPlayer play];
    [self.audioPlayer resume];
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
