//
//  HPVideoPlayerView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPVideoPlayerView.h"
#import "LGVideoInterfaceView.h"
#import "LGPlayer.h"
#import <PLPlayerKit/PLPlayerKit.h>

#import "HPAudioVideoViewController.h"

@interface HPVideoPlayerView ()<
LGPlayerDelegate,
LGVideoInterfaceViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *play;

@property (strong,nonatomic) UIView *playView;

/** if (played == YES),不是首次播放*/
@property (assign,nonatomic) BOOL played;
/** YES: 隐藏播放按钮 */
@property (assign,nonatomic) BOOL hidePlayButton;
/** YES: 总时间已经设置过 */
@property (assign,nonatomic) BOOL totalTimeSet;

@end

@implementation HPVideoPlayerView

#pragma mark - LGVideoInterfaceViewDelegate
- (void)videoInterfaceIViewFullScreenClick:(LGVideoInterfaceView *)videoInterface{
    /// TODO: 封装 playerView & 处理全屏播放 以及 交互
    
}

#pragma mark - LGPlayerDelegate
- (void)playProgress:(LGPlayer *)player progress:(float)progress currentTime:(float)currentTime totalTime:(float)totalTime{
    self.bottomInterface.progress.value = progress;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *currentString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    
    NSString *totalString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:totalTime]];
    
    
    self.bottomInterface.curTimeStr = currentString;
    /// 总时间，只设置一次
    if (!_totalTimeSet) {
        self.bottomInterface.totTimeStr = totalString;
        _totalTimeSet = YES;
    }
}
- (void)playerStateChanged:(LGPlayer *)player state:(LGPlayerState)state{
    NSLog(@"state -- %ld",state);
    if (state == 10) {
        _play.selected = NO;
        _played = NO;
        
    }
}

- (IBAction)play:(UIButton *)sender {
    _vc.opreated = YES;
    if (sender.isSelected) {
        sender.selected = NO;
//        [LGPlayer lg_pause];
    }else{
        if (!_played) {
//            BOOL play = [LGPlayer lg_play];
//            _played = play;
//            if (play) {
//                sender.selected = YES;
//                /// 隐藏播放按钮
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (!_hidePlayButton) {
//                        [self animatedShowPlayViewWith:NO];
//                    }
//                });
//            }
        }else{
//            [LGPlayer lg_resume];
        }
    }
    
}
- (void)tapPlayView:(UIGestureRecognizer *)gesture{
    if (_hidePlayButton) {
        [self animatedShowPlayViewWith:YES];
    }else{
        [self animatedShowPlayViewWith:NO];
    }
}

/** 显示/隐藏 播放按钮&底部交互，show 为YES 显示播放按钮 */
- (void)animatedShowPlayViewWith:(BOOL)show{
    _hidePlayButton = !show;
    CGFloat alpha;
    if (show) {
        alpha = 1;
    }else{
        alpha = 0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _play.alpha = alpha;
        self.bottomInterface.alpha = alpha;
    }];
}
//
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    UIView *playView = [LGPlayer playVideoWithUrl:nil];
//    self.playView = playView;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayView:)];
//    [playView addGestureRecognizer:tap];
//
//    playView.backgroundColor = [UIColor clearColor];
//    playView.frame = self.img.bounds;
//    [self addSubview:playView];
//
//
//    [self bringSubviewToFront:self.play];
//    [self bringSubviewToFront:self.bottomInterface];
//}
//
//- (void)awakeFromNib{
//    [super awakeFromNib];
//    [LGPlayer sharedInstance].delegate = self;
//    self.bottomInterface.delegate_fullScreen = self;
//}

//+ (instancetype)videoPlayerView{
//    return [[[NSBundle mainBundle] loadNibNamed:@"HPVideoPlayerView" owner:nil options:nil] lastObject];
//}

@end
