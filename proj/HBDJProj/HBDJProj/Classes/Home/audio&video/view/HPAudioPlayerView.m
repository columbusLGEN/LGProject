//
//  HPAudioPlayerView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAudioPlayerView.h"
#import "LGAudioPlayerView.h"
#import "LGGaussManager.h"

@interface HPAudioPlayerView ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *iconBg;
@property (weak, nonatomic) IBOutlet LGAudioPlayerView *audioPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@end

@implementation HPAudioPlayerView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    /// 高斯背景
    UIVisualEffectView *effectView = [LGGaussManager gaussViewWithFrame:_iconBg.bounds style:UIBlurEffectStyleLight];
    
    [_iconBg addSubview:effectView];
    [_iconBg bringSubviewToFront:_icon];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_icon cutBorderWithBorderWidth:0.5 borderColor:[UIColor whiteColor] cornerRadius:0];
    [_icon setShadowWithShadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.8 shadowRadius:15];
}

+ (instancetype)audioPlayerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPAudioPlayerView" owner:nil options:nil] lastObject];
}

@end
