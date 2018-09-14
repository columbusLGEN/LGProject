//
//  DJLessonDetailViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 新版 微党课 音视频控制器 --> 课程文稿为图文混排

#import "LGBaseViewController.h"

/** 党课多媒体类型 1:音频 2:视频 */
typedef NS_ENUM(NSUInteger, DJLessonMediaType) {
    /** 音频 */
    DJLessonMediaTypeAudio = 1,
    /** 视频 */
    DJLessonMediaTypeVideo
};

@class DJDataBaseModel,DJDataSyncer;

@interface DJLessonDetailViewController : LGBaseViewController

@property (assign,nonatomic) DJLessonMediaType lessonMediaType;
@property (strong,nonatomic) DJDataBaseModel *model;
/** 是否已经播放过,默认为NO */
@property (assign,nonatomic) BOOL opreated;

+ (void)lessonvcPushWithLesson:(DJDataBaseModel *)lesson baseVc:(UIViewController *)baseVc dataSyncer:(DJDataSyncer *)dataSyncer;

@property (strong,nonatomic) DJDataSyncer *dataSyncer;

@end
