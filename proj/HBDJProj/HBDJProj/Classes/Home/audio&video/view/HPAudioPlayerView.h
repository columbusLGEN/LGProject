//
//  HPAudioPlayerView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJMediaPlayDelegate.h"
@class DJDataBaseModel,DJLessonDetailViewController,LGAudioPlayerView;

@interface HPAudioPlayerView : UIView
@property (strong,nonatomic) DJDataBaseModel *model;
@property (weak,nonatomic) DJLessonDetailViewController *lessonDetailVc;
@property (weak, nonatomic) IBOutlet LGAudioPlayerView *audioPlayer;
@property (weak,nonatomic) id<DJMediaPlayDelegate> delegate;

- (void)audioStop;
+ (instancetype)audioPlayerView;

@end
