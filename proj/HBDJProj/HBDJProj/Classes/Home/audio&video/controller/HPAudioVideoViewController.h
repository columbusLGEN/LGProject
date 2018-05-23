//
//  HPAudioVideoViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 音视频 详情控制器

#import "LGBaseViewController.h"

typedef NS_ENUM(NSUInteger, HPAudioVideoType) {
    HPAudioVideoTypeVideo,
    HPAudioVideoTypeAudio,
};

@interface HPAudioVideoViewController : LGBaseViewController

@property (assign,nonatomic) HPAudioVideoType contentType;

@end
