//
//  LGAudioPlayerManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGAudioPlayerView.h"

@interface LGAudioPlayerManager : NSObject

/// 返回 player view
- (LGAudioPlayerView *)audioPlayerView;

- (void)stopPlay;

@property (assign,nonatomic) NSInteger audioTotalTime;

@end
