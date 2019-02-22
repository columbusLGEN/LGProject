//
//  LGCameraOperateViewController.m
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 Libc. All rights reserved.
//

#import "LGCameraOperateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LGCameraOperateViewController ()

@end

@implementation LGCameraOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// session
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    /// input
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    /// output
    AVCaptureOutput *videoOP = [AVCaptureVideoDataOutput new];
    captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    [captureSession addOutput:videoOP];
    [captureSession commitConfiguration];
    
    /// preview 去显示
    
}


@end
