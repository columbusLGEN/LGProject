//
//  HPAudioPlayerView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJDataBaseModel,HPAudioVideoViewController,DJLessonDetailViewController;

@interface HPAudioPlayerView : UIView
@property (strong,nonatomic) DJDataBaseModel *model;
@property (weak,nonatomic) HPAudioVideoViewController *vc;
@property (weak,nonatomic) DJLessonDetailViewController *lessonDetailVc;

- (void)audioStop;
+ (instancetype)audioPlayerView;

@end
