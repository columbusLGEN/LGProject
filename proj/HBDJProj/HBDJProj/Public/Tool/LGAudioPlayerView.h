//
//  LGAudioPlayerView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGAudioPlayerView : UIView
@property (strong,nonatomic) UIButton *play;
@property (strong,nonatomic) UILabel *currentTime;
@property (strong,nonatomic) UILabel *totalTime;

@property (assign,nonatomic) CGFloat progressValue;

@property (assign,nonatomic) NSInteger cTime;
@property (assign,nonatomic) NSInteger tTime;

@end
