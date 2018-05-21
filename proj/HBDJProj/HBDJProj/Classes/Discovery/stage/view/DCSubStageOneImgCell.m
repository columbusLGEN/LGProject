//
//  DCSubStageOneImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageOneImgCell.h"
#import "DCSubStageModel.h"

@interface DCSubStageOneImgCell ()
@property (strong,nonatomic) UIImageView *aImage;
@property (strong,nonatomic) UIButton *play;

@end

@implementation DCSubStageOneImgCell

- (void)play:(UIButton *)sender{
    NSLog(@"播放视频 -- ");
}

- (void)setModel:(DCSubStageModel *)model{
    [super setModel:model];
    _aImage.image = model.aTestImg;
    
    CGFloat aImgTopOffset = contentTopOffset + model.heightForContent + 10;
    
    if (model.aImgType == StageModelTypeAImgTypeVer) {
        [self.aImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(aImgTopOffset);
            make.width.mas_equalTo(aImgVerWidth);
            make.height.mas_equalTo(aImgVerHeight);
        }];
    }else{
        [self.aImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(aImgTopOffset);
            make.width.mas_equalTo(aImgHoriWidth);
            make.height.mas_equalTo(aImgHoriHeight);
        }];
    }
    
    if (!model.isVideo) {
        [self.play removeFromSuperview];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.aImage];
        [self.aImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(leftOffset);
        }];
        CGFloat playWidth = 40;
        [self.contentView addSubview:self.play];
        [self.play mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.aImage.mas_centerX);
            make.centerY.equalTo(self.aImage.mas_centerY);
            make.width.mas_equalTo(playWidth);
            make.height.mas_equalTo(playWidth);
        }];
    }
    return self;
}

- (UIImageView *)aImage{
    if (!_aImage) {
        _aImage = [UIImageView new];
        _aImage.clipsToBounds = YES;
        _aImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _aImage;
}
- (UIButton *)play{
    if (!_play) {
        _play = [UIButton new];
        [_play setImage:[UIImage imageNamed:@"dc_stage_video_play"] forState:UIControlStateNormal];
        [_play addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _play;
}

@end
