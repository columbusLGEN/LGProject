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

@end

@implementation HPVoiceSearchView

+ (instancetype)voiceSearchView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPVoiceSearchView" owner:nil options:nil] lastObject];
}

- (IBAction)begin:(id)sender {
    [LGVoiceRecoganizer lg_start];
    __block NSInteger i = 0;
    _timer = nil;
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
- (IBAction)close:(id)sender {
    [_timer invalidate];
    _timer = nil;
    if ([self.delegate respondsToSelector:@selector(voiceViewClose:)]) {
        [self.delegate voiceViewClose:self];
    }
}

@end
