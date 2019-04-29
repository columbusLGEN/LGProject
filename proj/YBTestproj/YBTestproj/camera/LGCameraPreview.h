//
//  LGCameraPreview.h
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/23.
//  Copyright © 2019 Libc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureVideoPreviewLayer;

NS_ASSUME_NONNULL_BEGIN

@interface LGCameraPreview : UIView

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *cameraPreviewLayer;
@property (strong,nonatomic) UIImageView *actionButton;

@end

NS_ASSUME_NONNULL_END
