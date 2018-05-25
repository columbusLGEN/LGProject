//
//  HPVideoPlayerView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPVideoPlayerView.h"
#import "LGVideoInterfaceView.h"
#import "LGPlayer.h"

@interface HPVideoPlayerView ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet LGVideoInterfaceView *bottomInterface;
@property (weak, nonatomic) IBOutlet UIButton *play;

@end

@implementation HPVideoPlayerView

- (IBAction)play:(id)sender {
    BOOL play = [LGPlayer videoPlay];
    NSLog(@"play -- %d",play);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *playView = [LGPlayer playVideoWithUrl:nil];
    playView.backgroundColor = [UIColor clearColor];
    playView.frame = self.img.bounds;
    [self addSubview:playView];
    
    [self bringSubviewToFront:self.play];
    [self bringSubviewToFront:self.bottomInterface];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

+ (instancetype)videoPlayerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPVideoPlayerView" owner:nil options:nil] lastObject];
}

@end
