//
//  LGPlayer.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGPlayer.h"
#import <PLPlayerKit/PLPlayerKit.h>

static NSString * const testVideo = @"http://123.59.197.176/group1/M00/00/0F/CgoKBFsHf3GAVgJbAV8r1CUcVnM073.mp4";
static NSString * const testAudio = @"http://123.59.197.176/group1/M00/00/0F/CgoKBFsHgSSAAvg8AHi9Md52w6k496.mp3";

@interface LGPlayer ()<PLPlayerDelegate>
@property (strong,nonatomic) PLPlayer *videoPlayer;
@property (strong,nonatomic) PLPlayer *audioPlayer;

@end

@implementation LGPlayer

+ (BOOL)videoPlay{
    return [[self sharedInstance] videoPlay];
}
- (BOOL)videoPlay{
    return [self.videoPlayer play];
}

+ (UIView *)playVideoWithUrl:(NSString *)urlString{
    return [[self sharedInstance] playVideoWithUrl:urlString];
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

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
