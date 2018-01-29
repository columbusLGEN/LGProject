//
//  ECRBookDownloadStateView.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/10/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRBookDownloadStateView.h"
#import "ECRDownloadStateModel.h"
#import "CircleProgressBar.h"

static CGFloat font = 11;
static NSString *cs_79CCF1 = @"79CCF1";// color string

@interface ECRBookDownloadStateView ()
// img view
@property (strong,nonatomic) UIImageView *imgView;//

// progress view --> 根据模型的状态 显示隐藏，仅在正在下载状态下显示
@property (strong,nonatomic) CircleProgressBar *progressView;// 下载进度条
// progress label
@property (strong,nonatomic) UILabel *aleadyCount;// 已完成百分比

// 按钮，通知模型开始下载，（暂停功能延后实现）
@property (strong,nonatomic) UIButton *btn;//

@end

@implementation ECRBookDownloadStateView

- (void)downloadClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(bdsView:beginDownloadWithModel:)]) {
        [self.delegate bdsView:self beginDownloadWithModel:self.model];
    }
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    // MARK: 设置进度
    _aleadyCount.text = [NSString stringWithFormat:@"%.0f",progress];
    [self.progressView setProgress:progress/100.0 animated:YES];
}

- (void)setModel:(ECRDownloadStateModel *)model{
    _model = model;
    // 设置数据
    
    [self.imgView setImage:model.img];
    [self.imgView sizeToFit];
    // 100、201、202、203 显示 下载按钮，否则隐藏
    if (model.modelState == ECRDownloadStateModelStateDownloadBegin || model.modelState == ECRDownloadStateModelStateDownloaded) {
        self.btn.hidden = YES;
    }else{
        self.btn.hidden = NO;
    }
    
    // 显示百分比
    if (model.modelState == ECRDownloadStateModelStateDownloadBegin || model.modelState == ECRDownloadStateModelStateDownloading) {
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width * 0.5 + 5;
        self.imgView.layer.masksToBounds = YES;
        self.progressView.hidden = NO;
        self.aleadyCount.hidden = NO;
        
    }else{
        self.progressView.hidden = YES;
        self.aleadyCount.hidden = YES;
    }
    
}

- (void)setupUI{
    CGFloat offset = 2;
    [self addSubview:self.progressView];
    [self addSubview:self.imgView];
    [self addSubview:self.btn];
    [self addSubview:self.aleadyCount];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(-offset);
        make.left.equalTo(self.imgView.mas_left).offset(-offset);
        make.bottom.equalTo(self.imgView.mas_bottom).offset(offset);
        make.right.equalTo(self.imgView.mas_right).offset(offset);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    [self.aleadyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (CircleProgressBar *)progressView{
    if (_progressView == nil) {
        _progressView = [[CircleProgressBar alloc] init];
        _progressView.progressBarWidth = 2;
        _progressView.progressBarTrackColor = [UIColor clearColor];
        _progressView.progressBarProgressColor = [UIColor colorWithHexString:cs_79CCF1];
        _progressView.startAngle = -90;
        _progressView.hintHidden = 1;
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}
- (UIImageView *)imgView{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}
- (UIButton *)btn{
    if (_btn == nil) {
        _btn = [[UIButton alloc] init];
        [_btn addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btn;
}
- (UILabel *)aleadyCount{
    if (_aleadyCount == nil) {
        _aleadyCount = [[UILabel alloc] init];
        _aleadyCount.font = [UIFont systemFontOfSize:font];
        _aleadyCount.textColor = [UIColor colorWithHexString:cs_79CCF1];
    }
    return _aleadyCount;
}

@end
