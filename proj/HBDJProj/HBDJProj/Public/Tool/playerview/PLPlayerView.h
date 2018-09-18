//
//  PLPlayerView.h
//  NiuPlayer
//
//  Created by hxiongan on 2018/3/7.lg_played
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLPlayerView,PLMediaInfo;
@protocol PLPlayerViewDelegate <NSObject>

- (void)playerViewEnterFullScreen:(PLPlayerView *)playerView;

- (void)playerViewExitFullScreen:(PLPlayerView *)playerView;

- (void)playerViewWillPlay:(PLPlayerView *)playerView;
/** 播放视频完成 */
- (void)playerViewCompleted:(PLPlayerView *)playerView;

- (void)lg_played;

@end

@interface PLPlayerView : UIView

@property (nonatomic, weak) id<PLPlayerViewDelegate> delegate;

@property (nonatomic, strong) PLMediaInfo *media;

- (void)play;

- (void)stop;

- (void)pause;

- (void)resume;

/// ---
- (void)lg_play_before;
- (void)lg_real_play;
/** 列表播放 按钮 */
@property (nonatomic, strong) UIButton *conPlay;
/** 展示连续播放按钮,在该项目中，朋友圈不展示连续播放按钮 */
@property (assign,nonatomic) BOOL showCPB;

@end


typedef enum : NSUInteger {
    PLPlayerRatioDefault,
    PLPlayerRatioFullScreen,
    PLPlayerRatio16x9,
    PLPlayerRatio4x3,
} PLPlayerRatio;


@class PLControlView;
@protocol PLControlViewDelegate <NSObject>

- (void)controlViewClose:(PLControlView *)controlView;

- (void)controlView:(PLControlView *)controlView speedChange:(CGFloat)speed;

- (void)controlView:(PLControlView *)controlView ratioChange:(PLPlayerRatio)ratio;

- (void)controlView:(PLControlView *)controlView backgroundPlayChange:(BOOL)isBackgroundPlay;

- (void)controlViewMirror:(PLControlView *)controlView;

- (void)controlViewRotate:(PLControlView *)controlView;

- (BOOL)controlViewCache:(PLControlView *)controlView;

@end

@interface PLControlView : UIView

@property (nonatomic, weak) id<PLControlViewDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *speedControl;
@property (nonatomic, strong) UISegmentedControl *ratioControl;
@property (nonatomic, strong) UILabel *speedValueLabel;
@property (nonatomic, strong) UILabel *speedTitleLabel;

@property (nonatomic, strong) UIButton *playBackgroundButton;
@property (nonatomic, strong) UIButton *mirrorButton;
@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *cacheButton;

- (void)resetStatus;
@end
