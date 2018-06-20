//
//  HPVideoPlayerView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 该类已经废弃

#import <UIKit/UIKit.h>
@class LGVideoInterfaceView,HPAudioVideoViewController;

@interface HPVideoPlayerView : UIView

@property (strong,nonatomic) HPAudioVideoViewController *vc;
@property (weak, nonatomic) IBOutlet LGVideoInterfaceView *bottomInterface;
//+ (instancetype)videoPlayerView;
@end
