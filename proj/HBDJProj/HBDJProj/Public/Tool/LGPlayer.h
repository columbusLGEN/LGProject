//
//  LGPlayer.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PLPlayerKit/PLPlayerKit.h>

/** 播放器状态 枚举 */
typedef NS_ENUM(NSUInteger, LGPlayerState) {
    LGPlayerStateCompleted = PLPlayerStatusCompleted,
    LGPlayerStateStopped = PLPlayerStatusStopped,
    LGPlayerStateError = PLPlayerStatusError,
    LGPlayerStateOther
};

@protocol LGPlayerDelegate;

@interface LGPlayer : NSObject

/** 进度跳转 */
+ (void)seekToProgress:(float)progress;
+ (void)lg_stop_play;
+ (BOOL)lg_play;
+ (void)lg_pause;
+ (void)lg_resume;
/** 初始化播放器 */
+ (UIView *)playVideoWithUrl:(NSString *)urlString;

@property (weak,nonatomic) id<LGPlayerDelegate> delegate;
+ (instancetype)sharedInstance;

@end

@protocol LGPlayerDelegate <NSObject>

/** 进度变化回调 */
- (void)playProgress:(LGPlayer *)player progress:(float)progress currentTime:(float)currentTime totalTime:(float)totalTime;
/** 播放器状态变化回调 */
- (void)playerStateChanged:(LGPlayer *)player state:(LGPlayerState)state;

@end
