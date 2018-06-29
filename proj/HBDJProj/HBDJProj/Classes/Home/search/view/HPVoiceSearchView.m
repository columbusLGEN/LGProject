//
//  HPVoiceSearchView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPVoiceSearchView.h"

@interface HPVoiceSearchView ()

@end

@implementation HPVoiceSearchView



- (IBAction)begin:(id)sender {
    /// 开始识别
    if ([self.delegate respondsToSelector:@selector(voiceViewRecording:)]) {
        [self.delegate voiceViewRecording:self];
    }
}
- (IBAction)close:(id)sender {
    /// 关闭页面
    if ([self.delegate respondsToSelector:@selector(voiceViewClose:)]) {
        [self.delegate voiceViewClose:self];
    }
}

+ (instancetype)voiceSearchView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPVoiceSearchView" owner:nil options:nil] lastObject];
}


@end
