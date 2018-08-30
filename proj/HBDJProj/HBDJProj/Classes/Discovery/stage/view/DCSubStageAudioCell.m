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
#import "DJUcMyCollectPYQModel.h"

@interface DCSubStageAudioCell ()
@property (strong,nonatomic) LGAudioPlayerView *audioPlayerView;


@end

@implementation DCSubStageAudioCell

- (void)setModel:(DCSubStageModel *)model{
    [super setModel:model];
    
    [self assiDataWithModel:model];
}

- (void)setMc_pyq_model:(DJUcMyCollectPYQModel *)mc_pyq_model{
    [super setMc_pyq_model:mc_pyq_model];
    [self assiDataWithModel:mc_pyq_model];
}

- (void)assiDataWithModel:(DCSubStageModel *)model{
    self.audioPlayerView.tTime = [model.audiolength integerValue];
    
    _audioPlayerView.play.selected = NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.audioPlayerView];
        
        [_audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom).offset(marginEight);
            make.left.equalTo(self.icon.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-leftOffset);
            make.height.mas_equalTo(62);
            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginEight);
        }];

        
    }
    return self;
}
- (LGAudioPlayerView *)audioPlayerView{
    if (!_audioPlayerView) {
        _audioPlayerView = [LGAudioPlayerView new];
        _audioPlayerView.layer.borderWidth = 1;
        _audioPlayerView.layer.borderColor = [UIColor EDJGrayscale_F3].CGColor;
        _audioPlayerView.userInteractionEnabled = NO;
    }
    return _audioPlayerView;
}

@end
