//
//  DJRecordVoiceViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJRecordVoiceViewController.h"
#import "LGKeepTimeLabel.h"

@interface DJRecordVoiceViewController ()
@property (weak,nonatomic) UIImageView *timerBg;
@property (weak,nonatomic) LGKeepTimeLabel *time;
@property (weak,nonatomic) UIButton *record;
/** 如果为YES，表示之前已经开始过了 */
@property (assign,nonatomic) BOOL began;

@end

@implementation DJRecordVoiceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    NSLog(@"bg.size: %@",NSStringFromCGSize(_timerBg.size));
    
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
}

- (void)recordDone:(UIButton *)button{
    [_time stop];
    
    
}

- (void)buttonClick:(UIButton *)button{
    if (!button.isSelected) {
        [_time fire];
        /// TODO: 开始录音
        
    }else{
        [_time pause];
        /// TODO: 暂停录音
    }
    button.selected = !button.isSelected;
    /// 次   点击之前.isSelected   点击之后.isSelected
    /// 1   NO                      YES
    /// 2   YES                     NO
    
}

@end
