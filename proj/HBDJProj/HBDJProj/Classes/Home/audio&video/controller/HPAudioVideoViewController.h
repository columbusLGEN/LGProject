//
//  HPAudioVideoViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 该类目前暂无实际用途
/// 音视频 详情控制器 （内容为纯文本）

#import "LGBaseViewController.h"
#import "DJDataBaseModel.h"

@class EDJHomeImageLoopModel,DJDataBaseModel;
//typedef NS_ENUM(NSUInteger, HPAudioVideoType) {
//    HPAudioVideoTypeVideo,
//    HPAudioVideoTypeAudio,
//};

@interface HPAudioVideoViewController : LGBaseViewController

@property (strong,nonatomic) EDJHomeImageLoopModel *imgLoopModel;
@property (assign,nonatomic) ModelMediaType contentType;
@property (strong,nonatomic) DJDataBaseModel *model;

// 是否已经播放过,默认为NO
@property (assign,nonatomic) BOOL opreated;

+ (void)avcPushWithLesson:(DJDataBaseModel *)lesson baseVc:(UIViewController *)baseVc;

@end
