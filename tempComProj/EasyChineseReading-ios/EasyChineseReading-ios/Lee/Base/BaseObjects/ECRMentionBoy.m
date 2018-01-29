//
//  ECRMentionBoy.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/4.
//  Copyright © 2017年 retech. All rights reserved.
//

static double oneHour = 1800;

#import "ECRMentionBoy.h"
#import "ECRMentionBoyView.h"

@interface ECRMentionBoy ()
/** 计时器 */
@property (strong,nonatomic) NSTimer *timer;//

@end

@implementation ECRMentionBoy

// 开启提示
+ (void)mentionUser{
    [[self sharedInstance] mentionUser];
}
- (void)mentionUser{
    self.timer = [NSTimer timerWithTimeInterval:oneHour target:self selector:@selector(addMentionBoyToWindow) userInfo:nil repeats:YES];
//    [self.timer fire];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
// 取消提示
+ (void)cancelMention{
    [[self sharedInstance] cancelMention];
}
- (void)cancelMention{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 直接添加到window上
+ (void)addMentionBoyToWindow{
    [[self sharedInstance] addMentionBoyToWindow];
}
- (void)addMentionBoyToWindow{
    ECRMentionBoyView *mbView = [ECRMentionBoyView mentionBoyView];
    mbView.frame = Screen_Bounds;
    [UIApplication.sharedApplication.keyWindow addSubview:mbView];
}

// Modal形式弹出
+ (void)loadTipsForOneHour{
    [[self sharedInstance] loadTipsForOneHour];
}
- (void)loadTipsForOneHour{
    ZAnimationTips *tips = [ZAnimationTips loadFromNib];
    tips.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    tips.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:tips animated:YES completion:nil];
}
// 单利
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
