//
//  HPAudioVideoInfoCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class DJDataBaseModel;

static NSString * const avInfoCell = @"HPAudioVideoInfoCell";

@protocol HPAudioVideoInfoCellDelegate;

@interface HPAudioVideoInfoCell : LGBaseTableViewCell

@property (strong,nonatomic) DJDataBaseModel *model;
@property (weak,nonatomic) id<HPAudioVideoInfoCellDelegate> delegate;
- (CGFloat)cellHeight;

@end

@protocol HPAudioVideoInfoCellDelegate <NSObject>
- (void)avInfoCellOpen:(HPAudioVideoInfoCell *)cell isOpen:(BOOL)isOpen;


@end
