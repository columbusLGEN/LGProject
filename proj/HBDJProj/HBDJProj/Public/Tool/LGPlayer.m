//
//  LGPlayer.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGPlayer.h"

static NSString * const testVideo = @"http://123.59.197.176/group1/M00/00/0F/CgoKBFsHf3GAVgJbAV8r1CUcVnM073.mp4";
static NSString * const testAudio = @"http://123.59.197.176/group1/M00/00/0F/CgoKBFsHgSSAAvg8AHi9Md52w6k496.mp3";

@interface LGPlayer ()<
PLPlayerDelegate>
@property (strong,nonatomic) PLPlayer *videoPlayer;
@property (strong,nonatomic) PLPlayer *audioPlayer;
@property (strong,nonatomic) NSTimer *playTimer;

@end

@implementation LGPlayer

#pragma mark - PLPlayerDelegate
- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if (state == 10 || state == 8) {
        [self removeTimer];
    }
    if ([self.delegate respondsToSelector:@selector(playerStateChanged:state:)]) {
        [self.delegate playerStateChanged:self state:state];
    }
}

- (UIView *)playVideoWithUrl:(NSString *)urlString{
    /// test
    urlString = testVideo;
    
    NSURL *url = [NSURL URLWithString:urlString];
    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    //    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    //    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    //    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    //    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    // 初始化 PLPlayer
    self.videoPlayer = [[PLPlayer alloc] initWithURL:url option:option];
    
    // 设定代理 (optional)
    self.videoPlayer.delegate = self;
    
    self.videoPlayer.playerView.contentMode = UIViewContentModeScaleToFill;
    //    playerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
    //    | UIViewAutoresizingFlexibleTopMargin
    //    | UIViewAutoresizingFlexibleLeftMargin
    //    | UIViewAutoresizingFlexibleRightMargin
    //    | UIViewAutoresizingFlexibleWidth
    //    | UIViewAutoresizingFlexibleHeight;
    
    return self.videoPlayer.playerView;
    
}

- (void)seekToProgress:(float)progress{
    float totalTime = CMTimeGetSeconds(self.videoPlayer.totalDuration);
    float destiTime = progress * totalTime;
    [self.videoPlayer seekTo:CMTimeMake(destiTime * 1000, 1000)];
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
    float currentTime = CMTimeGetSeconds(self.videoPlayer.currentTime);
    float totalTime = CMTimeGetSeconds(self.videoPlayer.totalDuration);
    
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
    NSLog(@"progress -- %f",progress);
}


- (BOOL)lg_play{
    [self addTimer];
    /// TODO: 音频 play
    return [self.videoPlayer play];
}
- (void)lg_pause{
    /// 记录当前进度
    [self.videoPlayer pause];
}
- (void)lg_resume{
    [self.videoPlayer resume];
}
- (void)lg_stop_play{
    [self removeTimer];
    [self.videoPlayer stop];
    [self.audioPlayer stop];
}

+ (void)seekToProgress:(float)progress{
    [[self sharedInstance] seekToProgress:progress];
}
+ (void)lg_stop_play{
    [[self sharedInstance] lg_stop_play];
}
+ (BOOL)lg_play{
    return [[self sharedInstance] lg_play];
}
+ (void)lg_pause{
    [[self sharedInstance] lg_pause];
}
+ (void)lg_resume{
    [[self sharedInstance] lg_resume];
}
+ (UIView *)playVideoWithUrl:(NSString *)urlString{
    return [[self sharedInstance] playVideoWithUrl:urlString];
}
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
@end
