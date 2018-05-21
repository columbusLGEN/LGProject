//
//  DCSubStageAudioCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageAudioCell.h"
#import "LGAudioPlayerView.h"

@interface DCSubStageAudioCell ()
@property (strong,nonatomic) LGAudioPlayerView *audio;

@end

@implementation DCSubStageAudioCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.audio];
        [_audio mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(contentTopOffset);
            make.left.equalTo(self.mas_left).offset(leftOffset);
            make.right.equalTo(self.mas_right).offset(-leftOffset);
            make.height.mas_equalTo(62);
        }];
//        CFIndex audioRetainCount = CFGetRetainCount((__bridge CFTypeRef)(self.audio));
//        NSLog(@"audioRetainCount -- %ld",audioRetainCount);
    }
    return self;
}
- (LGAudioPlayerView *)audio{
    if (!_audio) {
        _audio = [LGAudioPlayerView new];
        _audio.layer.borderWidth = 1;
        _audio.layer.borderColor = [UIColor EDJGrayscale_F3].CGColor;
    }
    return _audio;
}

@end
