//
//  DJRecordVoiceViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJRecordVoiceViewController.h"
#import "LGKeepTimeLabel.h"
#import "PLAudioRecorder.h"
#import "UCUploadViewController.h"
#import "LGAudioWav2Mp3Mgr.h"

@interface DJRecordVoiceViewController ()
@property (weak,nonatomic) UIImageView *timerBg;
@property (weak,nonatomic) LGKeepTimeLabel *time;
@property (weak,nonatomic) UIButton *record;
/** 如果为YES，表示之前已经开始过了 */
@property (assign,nonatomic) BOOL began;

@end

@implementation DJRecordVoiceViewController{
    PLAudioRecorder *audioRecorder;
    MBProgressHUD *uploadTipView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传音频";
    
    UIButton *done = UIButton.new;
    [done setTitle:@"完成" forState:UIControlStateNormal];
    [done setTitleColor:UIColor.EDJGrayscale_11 forState:UIControlStateNormal];
    [done addTarget:self action:@selector(recordDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [UIBarButtonItem.alloc initWithCustomView:done];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UIImageView *img = UIImageView.new;
    _timerBg = img;
    _timerBg.image = [UIImage imageNamed:@"dc_upload_audio_time"];
    _timerBg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_timerBg];
    
    LGKeepTimeLabel *time = [LGKeepTimeLabel.alloc initWithFrame:CGRectZero sec:0];
    _time = time;
    _time.textColor = UIColor.whiteColor;
    _time.font = [UIFont systemFontOfSize:44];
    _time.text = @"00:00:00";
    [self.view addSubview:_time];
    
    UIButton *button = UIButton.new;
    _record = button;
    [_record addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_record setImage:[UIImage imageNamed:@"dc_upload_audio_begin"] forState:UIControlStateNormal];
    [_record setImage:[UIImage imageNamed:@"dc_upload_audio_pause"] forState:UIControlStateSelected];
    [self.view addSubview:button];
    
    [_timerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(30 + kNavHeight);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_timerBg.mas_centerX);
        make.centerY.equalTo(_timerBg.mas_centerY);
    }];
    
    [_record mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
    _began = NO;
    
    [self initVoiceRecoder];
}

- (void)initVoiceRecoder{
    audioRecorder = [[PLAudioRecorder alloc] init];
    
    /**
     *  是否需要转码的逻辑判断，默认为NO
     当为NO是录制的格式是默认的wav格式，这种格式iOS是支持的；
     因为iOS支持的格式基本android都不支持，android支持的iOS全部都不支持，但是为了实现与android平台的IM互通，所以把iOS支持的wav转为android支持的amr
     所以这里可以设置isNeedConvert为yes，表示在录制完成后会转换成amr格式
     */
    audioRecorder.isNeedConvert=YES;
    
    
}

- (void)startRecord{

    NSString *oriPath = [PLAudioPath recordPathOrigin];
    
    NSString *mp3Path = [PLAudioPath mp3Path];
    
    [audioRecorder startRecordWithFilePath:oriPath
                              updateMeters:^(float meters){
                                  
                              }
                                   success:^(NSData *recordData){
                                       NSLog(@"录音成功");
                                       /// MARK: WAV 2 mp3
                                       [LGAudioWav2Mp3Mgr.new localPCMToMp3WithOriPath:oriPath desPath:mp3Path complete:^{
                                           [self pushUpvc];
                                       }];
                                   }
                                    failed:^(NSError *error){
                                        
                                    }];
    
}

- (void)pauseRecord{
    [audioRecorder pause];
}
- (void)resumeRecord{
    [audioRecorder resume];
}
/// MARK: 点击完成
- (void)recordDone:(UIButton *)button{
    if (!_began) {
        [self presentFailureTips:@"请先录音"];
        return;
    }
    [_time stop];
    [audioRecorder stopRecord];
    /// 添加提示 “资源文件处理中”
    uploadTipView = [MBProgressHUD wb_showActivityMessage:@"正在保存录音，请稍候..." toView:self.view];
}

- (void)pushUpvc{
    [uploadTipView hideAnimated:YES];
    uploadTipView = nil;
    UCUploadViewController *vc = UCUploadViewController.new;
    vc.pushWay = LGBaseViewControllerPushWayModal;
    vc.uploadAction = DJUPloadPyqActionAudio;
    vc.audioTotalTime = _time.sec;
    [self.navigationController pushViewController:vc animated:YES];
}

/// MARK: 录制按钮点击事件
- (void)buttonClick:(UIButton *)button{
    
    if (!button.isSelected) {

        if (_began) {
            [_time fire];
            /// 继续
            [self resumeRecord];
        }else{
            [_time fire];
            /// 首次播放
            [self startRecord];
            _began = YES;
        }
        
    }else{
        [_time pause];
        /// 暂停
        [self pauseRecord];
    }
    
    button.selected = !button.isSelected;
    /// 次   点击之前.isSelected   点击之后.isSelected
    /// 1   NO                      YES
    /// 2   YES                     NO
    
}

- (void)updateVolumeUI:(float )meters{
    /// 可设置波形
    //    float m = fabsf(meters);
    //
    //    NSInteger iconNumber = 3;
    //
    //    float scale = (60 - m )/60;
    
    //    if (scale <= 0.2f ){
    //        iconNumber = 1;
    //    } else if (scale > 0.2f && scale <= 0.4f) {
    //        iconNumber = 2;
    //    }else if (scale > 0.4f && scale <= 0.6f) {
    //        iconNumber = 3;
    //    }else if (scale > 0.6f && scale <= 0.8f) {
    //        iconNumber = 4;
    //    } else {
    //        iconNumber = 5;
    //    }
    //    label.hidden=NO;
    //    if (iconNumber==1) {
    //        label.font=[UIFont systemFontOfSize:10    ];
    //    }else if (iconNumber==2){
    //
    //        label.font=[UIFont systemFontOfSize:15    ];
    //    }else if (iconNumber==3){
    //        label.font=[UIFont systemFontOfSize:25    ];
    //
    //    }else if (iconNumber==4){
    //        label.font=[UIFont systemFontOfSize:45    ];
    //
    //    }else if (iconNumber==5){
    //        label.font=[UIFont systemFontOfSize:85    ];
    //
    //    }
    
    
}

@end
