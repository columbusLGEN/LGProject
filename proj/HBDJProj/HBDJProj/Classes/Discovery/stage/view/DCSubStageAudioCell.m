//
//  DCSubStageAudioCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageAudioCell.h"
#import "LGAudioPlayerView.h"
#import "LGThreeRightButtonView.h"
#import "DCSubStageModel.h"
#import "LGPlayer.h"

static NSString * const key_cTime = @"cTime";
static NSString * const key_tTime = @"tTime";
static NSString * const key_progress = @"progress";
static NSString * const key_playState = @"playState";

@interface DCSubStageAudioCell ()
@property (strong,nonatomic) LGAudioPlayerView *audioPlayerView;


@end

@implementation DCSubStageAudioCell{
    BOOL played;
    
}

- (void)setModel:(DCSubStageModel *)model{
    [super setModel:model];
    
    NSString *testUrl = @"http://123.59.199.170/group1/M00/00/0A/CgoKC1thHYSAHa0wAD_QsYXY-gQ944.mp3";
    [model.player initPlayerWithUrl:testUrl];
//    [self.player initPlayerWithUrl:model.fileurl];
    
    [model addObserver:self forKeyPath:key_cTime options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:key_tTime options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:key_progress options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:key_playState options:NSKeyValueObservingOptionNew context:nil];
}

/// TODO: cell 停止播放
- (void)audioCellStopPlay{
    [self.model.player lg_stop_play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.model) {
        
        if ([keyPath isEqualToString:key_cTime]) {
            self.audioPlayerView.cTime = self.model.cTime;
        }
        if ([keyPath isEqualToString:key_tTime]) {
            self.audioPlayerView.tTime = self.model.tTime;
        }
        if ([keyPath isEqualToString:key_progress]) {
//            NSLog(@"self.model.progress: %f",self.model.progress);
            self.audioPlayerView.progressValue = self.model.progress;
        }
        if ([keyPath isEqualToString:key_playState]) {
            if (self.model.playState == 10) {
                self.audioPlayerView.progressValue = 0;
                played = NO;
                _audioPlayerView.play.selected = NO;
            }
        }
    }
    
}

- (void)playAudio:(UIButton *)sender{
    if (sender.isSelected) {
        sender.selected = NO;
        /// 暂停
        [self.model.player lg_pause];
    }else{
        sender.selected = YES;
        if (!played) {
            /// 首次播放
            [self.model.player lg_play];
            self.audioPlayerView.progressValue = 0;
        }else{
            [self.model.player lg_resume];
        }
    }
    played = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.audioPlayerView];
        [_audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom).offset(marginEight);
            make.left.equalTo(self.contentView.mas_left).offset(leftOffset);
            make.right.equalTo(self.contentView.mas_right).offset(-leftOffset);
            make.height.mas_equalTo(62);
            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginEight);
        }];
        [_audioPlayerView.play addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return self;
}
- (LGAudioPlayerView *)audioPlayerView{
    if (!_audioPlayerView) {
        _audioPlayerView = [LGAudioPlayerView new];
        _audioPlayerView.layer.borderWidth = 1;
        _audioPlayerView.layer.borderColor = [UIColor EDJGrayscale_F3].CGColor;
    }
    return _audioPlayerView;
}


- (void)dealloc{
    [self.model removeObserver:self forKeyPath:key_cTime];
    [self.model removeObserver:self forKeyPath:key_tTime];
    [self.model removeObserver:self forKeyPath:key_progress];
    [self.model removeObserver:self forKeyPath:key_playState];
}

@end
