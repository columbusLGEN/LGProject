//
//  DJPyqAudioPlayViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJPyqAudioPlayViewController.h"
#import "LGAudioPlayerView.h"
#import "LGPlayer.h"
#import "DCSubStageModel.h"

@interface DJPyqAudioPlayViewController ()<LGPlayerDelegate>
@property (strong,nonatomic) LGAudioPlayerView *audioPlayerView;
@property (strong,nonatomic) LGPlayer *player;

@end

@implementation DJPyqAudioPlayViewController{
    
    BOOL totalTimeSet;
    BOOL played;
}

- (void)lg_dismissViewController{
    [self.player lg_stop_play];
    [super lg_dismissViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *close = [UIButton.alloc initWithFrame:self.view.bounds];
    [close setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [close addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    UIView *containerV = UIView.new;
    containerV.backgroundColor = UIColor.whiteColor;
    [containerV cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:5];
    [self.view addSubview:containerV];
    [containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(marginTwenty);
        make.right.equalTo(self.view.mas_right).offset(-marginTwenty);
        make.height.mas_equalTo(142);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    [containerV addSubview:self.audioPlayerView];
    [_audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerV.mas_left).offset(marginTwenty);
        make.right.equalTo(containerV.mas_right).offset(-marginTwenty);
        make.centerY.equalTo(containerV.mas_centerY);
        make.height.mas_equalTo(62);
    }];
    
    self.audioPlayerView.tTime = self.model.audiolength.integerValue;
    [self.player initPlayerWithUrl:self.model.fileurl];
    
}

- (void)playClick:(UIButton *)sender{
    if (sender.isSelected) {
        sender.selected = NO;
        /// 暂停
        [self.player lg_pause];
    }else{
        sender.selected = YES;
        if (!played) {
            /// 首次播放
            [self.player lg_play];
            self.audioPlayerView.progressValue = 0;
        }else{
            [self.player lg_resume];
        }
    }
    played = YES;
}

#pragma mark - LGPlayerDelegate
- (void)playProgress:(LGPlayer *)player progress:(float)progress currentTime:(float)currentTime totalTime:(float)totalTime{
    //    NSLog(@"%s",__func__);
    //    if (currentTime < 0) {
    //        currentTime = 0;
    //    }
    
    self.audioPlayerView.progressValue = progress;
//    [UIView animateWithDuration:1.0 animations:^{
//    }];
    
    self.audioPlayerView.cTime = currentTime;
    //    NSLog(@"给 model.cTime 赋值: %f",currentTime);
    /// 总时间，只设置一次
    //    NSLog(@"%@-总时间: %f",self.content,totalTime);
    if (!totalTimeSet) {
//        self.audioPlayerView.tTime = totalTime;
        totalTimeSet = YES;
    }
    
}
- (void)playerStateChanged:(LGPlayer *)player state:(LGPlayerState)state{
    if (state == 10) {
        self.audioPlayerView.progressValue = 1;
        played = NO;
        self.audioPlayerView.cTime = self.model.audiolength.integerValue;
        self.audioPlayerView.play.selected = NO;
    }
}

- (LGAudioPlayerView *)audioPlayerView{
    if (!_audioPlayerView) {
        _audioPlayerView = [LGAudioPlayerView new];
        _audioPlayerView.layer.borderWidth = 1;
        _audioPlayerView.layer.borderColor = [UIColor EDJGrayscale_F3].CGColor;
        [_audioPlayerView.play addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioPlayerView;
}
- (LGPlayer *)player{
    if (!_player) {
        _player = LGPlayer.new;
        _player.delegate = self;
    }
    return _player;
}

@end
