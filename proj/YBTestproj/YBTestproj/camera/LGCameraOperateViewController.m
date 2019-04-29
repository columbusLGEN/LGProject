//
//  LGCameraOperateViewController.m
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 Libc. All rights reserved.
//

#import "LGCameraOperateViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LGCameraPreview.h"

@interface LGCameraOperateViewController ()
//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *capMovieFileOutput;
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;
//负责输入和输出设备之间的数据传递
@property(nonatomic)AVCaptureSession *session;

@property (strong,nonatomic) LGCameraPreview *preview;
@property (weak,nonatomic) UIImageView *actionButton;

@end

@implementation LGCameraOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// TODO: 检查权限
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.preview];
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /// 3.session
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    
    /// 1.input
    /// 获取后置摄像头
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType: AVCaptureDeviceTypeBuiltInTelephotoCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    NSError *error = nil;
    /// 添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
//    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取的设备输入对象时出错，错误原因: %@",error);
    }
    
    /// 添加音频
    AVCaptureDeviceInput *audioCapDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入时出错: %@",error);
    }
    
    
    /// 2.output
    self.capMovieFileOutput = [AVCaptureMovieFileOutput new];
    
    
    if ([self.session canAddInput:self.captureDeviceInput]) {
        [self.session addInput:self.captureDeviceInput];
        [self.session addInput:audioCapDeviceInput];
        
        // 设置视频防抖
        AVCaptureConnection *connection = [self.capMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    if ([self.session canAddOutput:self.capMovieFileOutput]) {
        [self.session addOutput:self.capMovieFileOutput];
    }

    
//    [self.session commitConfiguration];
    
    /// preview 去显示
    self.preview.cameraPreviewLayer.session = self.session;
    
    [self.session startRunning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([[touches anyObject] view] == self.actionButton) {
        NSLog(@"开始录制: ");
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([[touches anyObject] view] == self.actionButton) {
        NSLog(@"结束触摸: ");
    }
}

- (LGCameraPreview *)preview{
    if (!_preview) {
        _preview = LGCameraPreview.new;
        _actionButton = _preview.actionButton;
    }
    return _preview;
}



@end
