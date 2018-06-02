//
//  HPVoiceSearchView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
@protocol HPVoiceSearchViewDelegate;

@interface HPVoiceSearchView : LGBaseView

@property (weak,nonatomic) id<HPVoiceSearchViewDelegate> delegate;
+ (instancetype)voiceSearchView;
@end

@protocol HPVoiceSearchViewDelegate <NSObject>

@optional
- (void)voiceViewClose:(HPVoiceSearchView *)voiceView;
- (void)voiceViewRecording:(HPVoiceSearchView *)voiceView;

@end
