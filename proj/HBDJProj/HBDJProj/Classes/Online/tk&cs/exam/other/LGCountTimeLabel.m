//
//  LGCountTimeLabel.m
//  countTime
//
//  Created by Peanut Lee on 2018/8/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGCountTimeLabel.h"

@interface LGCountTimeLabel ()
@property (assign,nonatomic) NSInteger sec;
@property (weak,nonatomic) NSTimer *timer;

@end

@implementation LGCountTimeLabel{
    NSInteger second;
    
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    NSLog(@"LGCountTimeLabel dealloc: ");
}

- (void)setSec:(NSInteger)sec{
    _sec = sec;
    
    self.text = timeStrWithSec(sec);
}

- (instancetype)initWithFrame:(CGRect)frame sec:(NSInteger)sec{
    second = sec;
    return [self initWithFrame:frame];
}
    
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self baseSetting];
    }
    return self;
}
- (void)baseSetting{
    
    self.textAlignment = NSTextAlignmentRight;
    
    __block NSInteger sec = second;
    
    if (@available(iOS 10.0, *)) {
        
        __weak typeof(self) weakSelf = self;
        NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            sec ++;
            strongSelf.sec = sec;
        }];
        
        [time fire];
        _timer = time;
    } else {
        // Fallback on earlier versions
    }
}


/**
 返回00:00:00格式时间的函数,需要参数：秒数

 @param sec 秒数
 */
NSString *timeStrWithSec(NSInteger sec){
    NSTimeInterval timeConsumed = sec;
    
    /// 将时间转化为 时:分:秒
    NSString *timeStr;
    if (timeConsumed > 3599 && timeConsumed <= 86400) {
        /// 超过一个小时
        NSInteger hour = timeConsumed / 3600;
        NSInteger hourOfSecond = hour * 3600;
        
        NSInteger min = (timeConsumed - hourOfSecond) / 60;
        NSInteger minOfSecond = min * 60;
        
        NSInteger sec = timeConsumed - hourOfSecond - minOfSecond;
        
        NSString *hourStr;
        if (hour < 10) {
            hourStr = [NSString stringWithFormat:@"0%ld",hour];
        }else{
            hourStr = [NSString stringWithFormat:@"%ld",hour];
        }
        
        NSString *minStr;
        if (min < 10) {
            minStr = [NSString stringWithFormat:@"0%ld",min];
        }else{
            minStr = [NSString stringWithFormat:@"%ld",min];
        }
        
        NSString *secStr;
        if (sec < 10) {
            secStr = [NSString stringWithFormat:@"0%ld",sec];
        }else{
            secStr = [NSString stringWithFormat:@"%ld",sec];
        }
        
        timeStr = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minStr,secStr];
        
    }else if (timeConsumed > 59){
        /// 超过一分钟
        NSInteger min = timeConsumed / 60;
        NSInteger minOfSecond = min * 60;
        
        NSInteger sec = timeConsumed - minOfSecond;
        
        NSString *minStr;
        if (min < 10) {
            minStr = [NSString stringWithFormat:@"0%ld",min];
        }else{
            minStr = [NSString stringWithFormat:@"%ld",min];
        }
        
        NSString *secStr;
        if (sec < 10) {
            secStr = [NSString stringWithFormat:@"0%ld",sec];
        }else{
            secStr = [NSString stringWithFormat:@"%ld",sec];
        }
        
        timeStr = [NSString stringWithFormat:@"%@:%@",minStr,secStr];
    }else{
        
        NSInteger sec = timeConsumed;
        
        NSString *secStr;
        if (timeConsumed < 10) {
            secStr = [NSString stringWithFormat:@"0%ld",sec];
        }else{
            secStr = [NSString stringWithFormat:@"%ld",sec];
        }
        
        timeStr = [NSString stringWithFormat:@"00:%@",secStr];
    }
    return timeStr;
}

@end
