//
//  DJLessonAVTextTableViewCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 新版党课 影视频 课程文稿cell

//#import "LGBaseTableViewCell.h"
#import "DCStateContentsCell.h"

static NSString * const lessonAVTextCell = @"DJLessonAVTextTableViewCell";

@class DJDataBaseModel;

@interface DJLessonAVTextTableViewCell : DCStateContentsCell
@property (strong,nonatomic) DJDataBaseModel *model;

@end
