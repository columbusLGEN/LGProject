//
//  HPVideoContainerView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPVideoContainerView.h"
#import "PLPlayerView.h"
#import "PLMediaInfo.h"
#import "DJDataBaseModel.h"

#import "HPAudioVideoViewController.h"

static NSString * const testVideo = @"http://123.59.197.176/group1/M00/00/0F/CgoKBFsXS3WAMVzsAV8r1CUcVnM988.mp4";

@interface HPVideoContainerView ()<
PLPlayerViewDelegate>

@property (weak,nonatomic) PLPlayerView *playerView;
@property (nonatomic, assign) BOOL isFullScreen;
@property (assign,nonatomic) CGRect originFrame;

@end

@implementation HPVideoContainerView

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    /// 设置数据
    PLMediaInfo *media = [PLMediaInfo new];
    /// TODO: 封面？ /// 视频连接？
    media.thumbURL = @"http://a.hiphotos.baidu.com/image/pic/item/0df3d7ca7bcb0a46aa1f61a36763f6246b60af6f.jpg";
    media.videoURL = testVideo;
    
    _playerView.media = media;
}

- (void)stop{
    [_playerView stop];
}

#pragma mark - PLPlayerViewDelegate
- (void)playerViewEnterFullScreen:(PLPlayerView *)playerView;{
    UIView *superView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [playerView removeFromSuperview];
    [superView addSubview:playerView];
    [playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superView.mas_height);
        make.height.equalTo(superView.mas_width);
        make.center.equalTo(superView);
    }];
    
    [superView setNeedsUpdateConstraints];
    [superView updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [superView layoutIfNeeded];
    }];
    
    [self enterFullScreen];
}
- (void)enterFullScreen {
    self.isFullScreen = YES;
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)playerViewExitFullScreen:(PLPlayerView *)playerView;{
    
    [playerView removeFromSuperview];
    [self addSubview:playerView];
    
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    [self exitFullScreen];
}

- (void)lg_played{
    self.vc.opreated = YES;
}

- (void)exitFullScreen{
    self.isFullScreen = NO;
//    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)playerViewWillPlay:(PLPlayerView *)playerView;{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        PLPlayerView *playerView = [[PLPlayerView alloc] init];
        [self addSubview:playerView];
        
        [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        playerView.delegate = self;
        
        _playerView = playerView;
    }
    return self;
}


@end
