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

/** 定位到指定位置 */
- (void)seekToWithProgress:(CGFloat)progress;
/** 当前播放器是否播放中 */
- (BOOL)isPlaying;

- (void)initPlayerWithUrl:(NSString *)url;
- (void)seekToProgress:(float)progress;
- (void)lg_stop_play;
- (void)lg_play;
- (void)lg_pause;
- (void)lg_resume;


@property (weak,nonatomic) id<LGPlayerDelegate> delegate;

@end

@protocol LGPlayerDelegate <NSObject>

/** 进度变化回调 */
- (void)playProgress:(LGPlayer *)player progress:(float)progress currentTime:(float)currentTime totalTime:(float)totalTime;
/** 播放器状态变化回调 */
- (void)playerStateChanged:(LGPlayer *)player state:(LGPlayerState)state;

@end
