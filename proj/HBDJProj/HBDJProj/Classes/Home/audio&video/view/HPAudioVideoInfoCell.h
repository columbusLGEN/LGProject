//
//  HPAudioVideoInfoCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

static NSString * const avInfoCell = @"HPAudioVideoInfoCell";

@protocol HPAudioVideoInfoCellDelegate;

@interface HPAudioVideoInfoCell : LGBaseTableViewCell

@property (weak,nonatomic) id<HPAudioVideoInfoCellDelegate> delegate;

@end

@protocol HPAudioVideoInfoCellDelegate <NSObject>
- (void)avInfoCellOpen:(HPAudioVideoInfoCell *)cell isOpen:(BOOL)isOpen;

@end
