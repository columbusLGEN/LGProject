//
//  DCSubStageOneImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageOneImgCell.h"
#import "DCSubStageModel.h"
#import "LGThreeRightButtonView.h"
#import "HZPhotoBrowser.h"
#import "DJUcMyCollectPYQModel.h"

@interface DCSubStageOneImgCell ()
@property (strong,nonatomic) UIImageView *aImage;
@property (strong,nonatomic) UIButton *play;

@end

@implementation DCSubStageOneImgCell

//// 返回高质量图片的url
//- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    NSString *urlStr = [self.urlArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//    return [NSURL URLWithString:urlStr];
//}

- (void)setModel:(DCSubStageModel *)model{
    [super setModel:model];
    
    [self assiDataWithModel:model];
}

- (void)setMc_pyq_model:(DJUcMyCollectPYQModel *)mc_pyq_model{
    [super setMc_pyq_model:mc_pyq_model];
    [self assiDataWithModel:mc_pyq_model];
}

- (void)assiDataWithModel:(DCSubStageModel *)model{
    if (model.filetype == 1) {
        [_aImage sd_setImageWithURL:[NSURL URLWithString:model.fileurl] placeholderImage:DJPlaceholderImage];
    }
    if (model.filetype == 2) {
        [_aImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    }
    
    CGFloat aImgTopOffset = contentTopOffset + model.heightForContent + 10;
    
    if (model.aImgType == StageModelTypeAImgTypeVer) {
        [self.aImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_top).offset(aImgTopOffset);
            make.width.mas_equalTo(aImgVerWidth);
            make.height.mas_equalTo(aImgVerHeight);
            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginEight);
        }];
    }else{
        [self.aImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(aImgTopOffset);
            make.width.mas_equalTo(aImgHoriWidth);
            make.height.mas_equalTo(aImgHoriHeight);
            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginEight);
        }];
    }
    
    if (!model.isVideo) {
        self.play.hidden = YES;
    }else{
        self.play.hidden = NO;
    }
}

- (void)play:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(pyqCellplayVideoWithModel:)]) {
        [self.delegate pyqCellplayVideoWithModel:self.model];
    }
}

- (void)imageTap:(UIGestureRecognizer *)tap{
    if (self.model.filetype == 1) {
        if ([self.delegate respondsToSelector:@selector(pyqCellOneImageClick:model:imageView:)]) {
            [self.delegate pyqCellOneImageClick:self model:self.model imageView:_aImage];
        }
    }
}

#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.aImage.image;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.aImage];
        [self.aImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_left);
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
        
        UITapGestureRecognizer *tapImg = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(imageTap:)];
        _aImage.userInteractionEnabled = YES;
        [_aImage addGestureRecognizer:tapImg];
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
