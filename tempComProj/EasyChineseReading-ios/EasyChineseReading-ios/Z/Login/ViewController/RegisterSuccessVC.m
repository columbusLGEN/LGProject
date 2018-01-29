//
//  RegisterSuccessVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "RegisterSuccessVC.h"

@interface RegisterSuccessVC ()

/* 成功标志 */
@property (strong, nonatomic) UIImageView *imgSuccess;
/* 主要描述 */
@property (strong, nonatomic) UILabel *lblDesc;
/* 次要描述 */
@property (strong, nonatomic) UILabel *lblSubDesc;
/* 计时器 */
@property (strong, nonatomic) NSTimer *timer;
/* 倒计时时间 */
@property (assign, nonatomic) NSInteger timeDown;

@end

@implementation RegisterSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _timeDown = 3;
    [self configTimer];
    [self configRegisterSuccessView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"注册成功");
}

- (void)baseViewControllerDismiss
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 配置成功界面
- (void)configRegisterSuccessView
{
    CGFloat imgWidth = 100;
    _imgSuccess = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgWidth, imgWidth)];
    _imgSuccess.image = [UIImage imageNamed:@"img_success"];
    [self.view addSubview:_imgSuccess];
    WeakSelf(self)
    [_imgSuccess mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64 + 80);
    }];
    
    _lblDesc = [UILabel new];
    _lblDesc.text = LOCALIZATION(@"恭喜您，注册成功！");
    _lblDesc.font = [UIFont systemFontOfSize:16.f];
    _lblDesc.textColor = [UIColor cm_grayColor__807F7F_1];
    [self.view addSubview:_lblDesc];
    [_lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.top.equalTo(self.imgSuccess.mas_bottom).offset(22);
        make.centerX.equalTo(self.imgSuccess.mas_centerX);
    }];
    
    _lblSubDesc = [UILabel new];
    _lblSubDesc.text =  _userType == ENUM_UserTypeOrganization ? [NSString stringWithFormat:@"%@ %lds", LOCALIZATION(@"请等待管理员3天内与您联系"), _timeDown] : [NSString stringWithFormat:@"%@ %lds ...", LOCALIZATION(@"返回用户中心"), _timeDown];
    _lblSubDesc.font = [UIFont systemFontOfSize:14.f];
    _lblSubDesc.textColor = [UIColor cm_grayColor__807F7F_1];
    [self.view addSubview:_lblSubDesc];
    [_lblSubDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.top.equalTo(self.lblDesc.mas_bottom).offset(28);
        make.centerX.equalTo(self.lblDesc.mas_centerX);
    }];
}

#pragma mark - 配置计时器

/** 配置计时器 */
- (void)configTimer
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    });
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];    
}

/** 实现计时器方法 */
- (void)timerFireMethod:(NSTimer *)timer
{
    if (_timeDown > 0) {
        _timeDown -= 1;
        _lblSubDesc.text =  _userType == ENUM_UserTypeOrganization ? [NSString stringWithFormat:@"%@ %lds", LOCALIZATION(@"请等待管理员3天内与您联系"), _timeDown] : [NSString stringWithFormat:@"%@ %lds ...", LOCALIZATION(@"返回用户中心"), _timeDown];
    }
    else {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
