//
//  DCSubStageBaseTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 发现  党员舞台 单元格

#import "DJUcMyCollectTableViewCell.h"
#import "HZPhotoBrowser.h"

@class DCSubStageModel,LGThreeRightButtonView,DCSubStageBaseTableViewCell,DJUcMyCollectPYQModel;

@protocol DCSubStageBaseTableViewCellDelegate <NSObject>
- (void)pyqLikeWithModel:(DCSubStageModel *)model sender:(UIButton *)sender;
- (void)pyqCollectWithModel:(DCSubStageModel *)model sender:(UIButton *)sender;
- (void)pyqCommentWithModel:(DCSubStageModel *)model sender:(UIButton *)sender;

- (void)pyqCellplayVideoWithModel:(DCSubStageModel *)model;
- (void)pyqCellOneImageClick:(DCSubStageBaseTableViewCell *)cell model:(DCSubStageModel *)model imageView:(UIImageView *)imageView;

@end

static NSString * const subStageBaseCell = @"DCSubStageBaseTableViewCell";
static NSString * const oneImgCell = @"DCSubStageOneImgCell";
static NSString * const threeImgCell = @"DCSubStageThreeImgCell";
static NSString * const audioCell = @"DCSubStageAudioCell";

/** 党员舞台cell内容距离顶部的间距，这个间距之间放置着头像和昵称 */
static CGFloat contentTopOffset = 56;
/** 党员舞台cell统一的左边距 */
static CGFloat leftOffset = 15;

@interface DCSubStageBaseTableViewCell : DJUcMyCollectTableViewCell<HZPhotoBrowserDelegate>
@property (weak,nonatomic) id<DCSubStageBaseTableViewCellDelegate> delegate;
@property (strong,nonatomic) DCSubStageModel *model;
@property (strong,nonatomic) DJUcMyCollectPYQModel *mc_pyq_model;/// mc: my collect
@property (strong, nonatomic) UILabel *content;/// 文本内容
@property (strong, nonatomic) UIImageView *icon;/// 头像
@property (strong, nonatomic) LGThreeRightButtonView *boInterView;/// 底部交互按钮

@end
