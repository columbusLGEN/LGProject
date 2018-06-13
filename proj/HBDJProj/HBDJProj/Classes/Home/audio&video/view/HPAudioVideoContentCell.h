//
//  HPAudioVideoContentCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class DJDataBaseModel;

static NSString * const avContentCell = @"HPAudioVideoContentCell";

@interface HPAudioVideoContentCell : LGBaseTableViewCell
@property (strong,nonatomic) DJDataBaseModel *model;

@end
