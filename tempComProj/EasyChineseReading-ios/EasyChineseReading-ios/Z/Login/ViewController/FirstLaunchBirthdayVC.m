//
//  FirstLaunchBirthdayVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "FirstLaunchBirthdayVC.h"

@interface FirstLaunchBirthdayVC ()

@property (strong, nonatomic) UIImageView *imgBackground;   // 背景图
@property (strong, nonatomic) UIDatePicker *datePicker;     // 时间选择器
@property (strong, nonatomic) UIButton    *btnNext;         // 下一步

@property (strong, nonatomic) UIImageView *imgHeader;       // 顶部图片
@property (strong, nonatomic) UIImageView *imgHeaderDesc;   // 描述图片
@property (strong, nonatomic) UIImageView *imgIcon;         // 时间小图标
@property (strong, nonatomic) UIView *topLine;              // 时间选择器顶部线
@property (strong, nonatomic) UIView *botLine;              // 时间选择器底部线

@end

@implementation FirstLaunchBirthdayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBirthdayView];
}

#pragma mark - 配置选择生日界面

- (void)configBirthdayView
{
    CGFloat kPickerWidth  = 260.f;
    CGFloat kPickerHeight = 180.f;
    
    _imgBackground = [UIImageView new];
    _imgBackground.image = isPad ? [UIImage imageNamed:@"img_background_launchScreen_pad"] : [UIImage imageNamed:@"img_background_launchScreen"];
    [self.view addSubview:_imgBackground];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kPickerWidth, kPickerHeight)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.date = [NSDate date];
    _datePicker.maximumDate = [NSDate date];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"En"];
    _datePicker.locale = locale;
    [self.view addSubview:_datePicker];
    
    _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 86*2, cButtonHeight_40)];
    _btnNext.backgroundColor = [UIColor cm_yellowColor_FFE402_1];
    _btnNext.titleLabel.font = [UIFont systemFontOfSize:cFontSize_16];
    _btnNext.titleLabel.textColor = [UIColor whiteColor];
    _btnNext.layer.cornerRadius  = _btnNext.height/2;
    _btnNext.layer.masksToBounds = YES;
    [_btnNext setTitle:@"OK" forState:UIControlStateNormal];
    [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnNext addTarget:self action:@selector(endSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnNext];
    
    _imgHeader = [UIImageView new];
    _imgHeader.image = [UIImage imageNamed:@"img_launch_header_birthday"];
    [self.view addSubview:_imgHeader];
    
    _imgHeaderDesc = [UIImageView new];
    _imgHeaderDesc.image = [UIImage imageNamed:@"img_launch_date_of_birth"];
    [self.view addSubview:_imgHeaderDesc];
    
    _imgIcon = [UIImageView new];
    _imgIcon.image = [UIImage imageNamed:@"icon_launch_birthday"];
    [self.view addSubview:_imgIcon];
    
    _topLine = [UIView new];
    _topLine.backgroundColor = [UIColor cm_yellowColor_FFE402_1];
    [self.view addSubview:_topLine];
    
    _botLine = [UIView new];
    _botLine.backgroundColor = [UIColor cm_yellowColor_FFE402_1];
    [self.view addSubview:_botLine];
    
    [_imgBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size   .mas_equalTo(CGSizeMake(kPickerWidth, kPickerHeight));
    }];
    [_btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom .mas_equalTo(self.view.mas_bottom).offset(isPad ? -100 : -cHeaderHeight_44);
        make.size   .mas_equalTo(CGSizeMake(self.view.width - 86*2, cButtonHeight_40));
    }];
    
    [_imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.top).offset(isPad ? 150.f : cHeaderHeight_64);
    }];
    [_imgHeaderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(_imgHeader.mas_bottom).offset(30);
    }];
    [_imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_datePicker.mas_centerY);
        make.right.mas_equalTo(_datePicker.mas_left).offset(-10);
    }];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_datePicker.mas_leading);
        make.trailing.mas_equalTo(_datePicker.mas_trailing);
        make.bottom.mas_equalTo(_datePicker.mas_top);
        make.height.mas_equalTo(3.f);
    }];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_datePicker.mas_leading);
        make.trailing.mas_equalTo(_datePicker.mas_trailing);
        make.top.mas_equalTo(_datePicker.mas_bottom);
        make.height.mas_equalTo(3.f);
    }];
}

/** 确认选择 */
- (void)endSelected
{
    [[CacheDataSource sharedInstance] setCache:@"YES" withCacheKey:CacheKey_NotFirstTime];
    
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:date];
    // TODO: 选择皮肤
    
    CountryModel *country = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_SelectCountry];
    if ([country.zh_name isEqualToString:@"中国"] || [country.zh_name isEqualToString:@"中国香港"] || [country.zh_name isEqualToString:@"中国台湾"] || [country.zh_name isEqualToString:@"中国澳门"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    }
    [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[CacheDataSource sharedInstance] setCache:strDate withCacheKey:CacheKey_SelectBirthday];
    CLMTabBarController *tab = [[CLMTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeOglFlip subType:TransitionSubtypesFromRight curve:TransitionCurveEaseOut duration:cAnimationTime];
}

@end
