//
//  LGVoiceRecoAssist.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGVoiceRecoAssist.h"
/// MARK: VOICE 语音识别类（对科大讯飞的封装）
#import "LGVoiceRecoganizer.h"

@interface LGVoiceRecoAssist ()
@property (strong,nonatomic) NSTimer *timer;

@end

@implementation LGVoiceRecoAssist

#pragma mark - LGVoiceRecoganizerDelegate
- (void)lg_endOfSpeech:(NSNotification *)notification{
    [_timer invalidate];
    _timer = nil;
    
    /// 通知代理
    if ([self.delegate respondsToSelector:@selector(voiceRecoAssistEndRecoganize)]) {
        [self.delegate voiceRecoAssistEndRecoganize];
    }
}

- (void)start{
    [LGVoiceRecoganizer lg_start];
    __block NSInteger i = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if ([self.delegate respondsToSelector:@selector(voiceRecoAssistRecoganizing:)]) {
            [self.delegate voiceRecoAssistRecoganizing:i];
        }
        i++;
        if (i == 3) {
            i = 0;
        }
    }];
    
    [_timer fire];
}

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lg_endOfSpeech:) name:LGVoiceRecoganizerEndOfSpeechNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
