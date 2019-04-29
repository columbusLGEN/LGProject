//
//  LGCameraPreview.m
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/23.
//  Copyright © 2019 Libc. All rights reserved.
//

#import "LGCameraPreview.h"
#import <AVFoundation/AVFoundation.h>

@interface LGCameraPreview ()
@property (copy,nonatomic) UILabel *notice;

@end

@implementation LGCameraPreview

+ (Class)layerClass{
    return [AVCaptureVideoPreviewLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cameraPreviewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
        
        [self addSubview:self.notice];
        [self addSubview:self.actionButton];
        /// “轻按拍照，长按摄像”
        [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.actionButton.mas_top).offset(-20);
        }];
        /// 拍照按钮
        
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-100);
            make.width.height.mas_equalTo(60);
        }];
        /// 问专家 + s听恢复
        
    }
    return self;
}

- (UILabel *)notice{
    if (!_notice) {
        _notice = UILabel.new;
        _notice.text = @"轻按拍照，长按摄像";
        _notice.textColor = UIColor.whiteColor;
    }
    return _notice;
}
- (UIImageView *)actionButton{
    if (!_actionButton) {
        _actionButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hVideo_take"]];
        _actionButton.userInteractionEnabled = YES;
    }
    return _actionButton;
}

@end
