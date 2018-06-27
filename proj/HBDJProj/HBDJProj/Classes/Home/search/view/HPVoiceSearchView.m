//
//  HPVoiceSearchView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPVoiceSearchView.h"
#import "LGVoiceRecoganizer.h"

@interface HPVoiceSearchView ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong,nonatomic) NSTimer *timer;

@property (assign,nonatomic) BOOL searching;

@end

@implementation HPVoiceSearchView

#pragma mark - LGVoiceRecoganizerDelegate
- (void)lg_endOfSpeech:(NSNotification *)notification{
    [_timer invalidate];
    _timer = nil;
    _searching = NO;
    [self.icon setImage:[UIImage imageNamed:@"home_voice_begin"]];
}

- (IBAction)begin:(id)sender {
    if (!_searching) {
        [LGVoiceRecoganizer lg_start];
        __block NSInteger i = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self.icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_voice_searching_%ld",i]]];
            i++;
            if (i == 3) {
                i = 0;
            }
        }];
        
        [_timer fire];
        
        if ([self.delegate respondsToSelector:@selector(voiceViewRecording:)]) {
            [self.delegate voiceViewRecording:self];
        }
    }
    _searching = YES;
}
- (IBAction)close:(id)sender {
    [_timer invalidate];
    _timer = nil;
    if ([self.delegate respondsToSelector:@selector(voiceViewClose:)]) {
        [self.delegate voiceViewClose:self];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _searching = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lg_endOfSpeech:) name:LGVoiceRecoganizerEndOfSpeechNotification object:nil];
}

+ (instancetype)voiceSearchView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPVoiceSearchView" owner:nil options:nil] lastObject];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
