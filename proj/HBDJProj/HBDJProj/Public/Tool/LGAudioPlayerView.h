//
//  LGAudioPlayerView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGAudioPlayerView;

@protocol LGAudioPlayerViewDelegate <NSObject>
- (void)avSliderValueChanged:(LGAudioPlayerView *)view slider:(UISlider *)slider;

@end

@interface LGAudioPlayerView : UIView
@property (weak,nonatomic) id<LGAudioPlayerViewDelegate> delegate;
@property (strong,nonatomic) UIButton *play;
@property (strong,nonatomic) UILabel *currentTime;
@property (strong,nonatomic) UILabel *totalTime;
/** 连续播放按钮 */
@property (strong,nonatomic) UIButton *conPlay;
/** 展示连续播放按钮,在该项目中，朋友圈不展示连续播放按钮 */
@property (assign,nonatomic) BOOL showCPB;

@property (assign,nonatomic) CGFloat progressValue;

@property (assign,nonatomic) NSInteger cTime;
@property (assign,nonatomic) NSInteger tTime;

@end
