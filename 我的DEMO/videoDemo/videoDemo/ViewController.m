//
//  ViewController.m
//  videoDemo
//
//  Created by Peanut Lee on 2018/3/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface ViewController ()<PLPlayerDelegate>
/** */
@property (strong,nonatomic) PLPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];

    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
//    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
//    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
//    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    // 初始化 PLPlayer
    self.player = [[PLPlayer alloc] initWithURL:url option:option];
    
    // 设定代理 (optional)
    self.player.delegate = self;
    
    UIView *playerView = self.player.playerView;
    playerView.backgroundColor = [UIColor orangeColor];
//    playerView.contentMode = UIViewContentModeScaleAspectFit;
//    playerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
//    | UIViewAutoresizingFlexibleTopMargin
//    | UIViewAutoresizingFlexibleLeftMargin
//    | UIViewAutoresizingFlexibleRightMargin
//    | UIViewAutoresizingFlexibleWidth
//    | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:playerView];

    BOOL play = [self.player play];
    NSLog(@"是否播放成功 -- %d",play);
    
}

#pragma mark - PLPlayerDelegate
// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
    // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
    // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
    // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
    // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    NSLog(@"state -- %zd",state);
}
- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
