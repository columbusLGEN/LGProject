//
//  HPAudioPlayerCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPAudioPlayerCell.h"
#import "LGAudioPlayerView.h"

@interface HPAudioPlayerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *iconBg;
@property (weak, nonatomic) IBOutlet LGAudioPlayerView *audioPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;


@end

@implementation HPAudioPlayerCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    /// 高斯背景
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = _iconBg.bounds;
    
    [_iconBg addSubview:effectView];
    [_iconBg bringSubviewToFront:_icon];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_icon setShadowWithShadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(10, 10) shadowOpacity:1 shadowRadius:10];
    [_icon cutBorderWithBorderWidth:0.5 borderColor:[UIColor whiteColor] cornerRadius:0];
}


@end
