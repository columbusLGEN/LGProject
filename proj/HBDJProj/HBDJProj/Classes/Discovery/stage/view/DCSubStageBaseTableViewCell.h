//
//  DCSubStageBaseTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 发现  党员舞台 单元格

#import "LGBaseTableViewCell.h"

@class DCSubStageModel;

static NSString * const subStageBaseCell = @"DCSubStageBaseTableViewCell";
static NSString * const oneImgCell = @"DCSubStageOneImgCell";
static NSString * const threeImgCell = @"DCSubStageThreeImgCell";
static NSString * const audioCell = @"DCSubStageAudioCell";

/** 党员舞台cell内容距离顶部的间距，这个间距之间放置着头像和昵称 */
static CGFloat contentTopOffset = 56;
/** 党员舞台cell统一的左边距 */
static CGFloat leftOffset = 15;

@interface DCSubStageBaseTableViewCell : LGBaseTableViewCell

@property (strong,nonatomic) DCSubStageModel *model;

@end
