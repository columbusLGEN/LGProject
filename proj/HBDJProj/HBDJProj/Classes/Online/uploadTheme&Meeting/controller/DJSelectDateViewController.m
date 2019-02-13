//
//  DJSelectDateViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSelectDateViewController.h"

@interface DJSelectDateViewController ()
@property (strong,nonatomic) UIButton *shadow;

@property (strong,nonatomic) UIView *container;
@property (strong,nonatomic) UILabel *item;
@property (strong,nonatomic) UILabel *currentTime;
@property (strong,nonatomic) UIView *line;
@property (strong,nonatomic) UISegmentedControl *segment;
@property (strong,nonatomic) UIDatePicker *datePicker;

@end

@implementation DJSelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)lg_dismissViewController{
    if ([self.delegate respondsToSelector:@selector(selectDate:dateString:cellIndex:)]) {
        [self.delegate selectDate:self dateString:_currentTime.text cellIndex:_cellIndex];
    }
    [super lg_dismissViewController];
}

#pragma mark - target
- (void)segmentChanged:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    if (segment.selectedSegmentIndex == 1) {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
}
- (void)dateChanged:(UIDatePicker *)datePicker{
    _currentTime.text =  [self timeStringWithDate:datePicker.date dateFormat:[self dateFormat]];
}

- (void)configUI{
    self.pushWay = LGBaseViewControllerPushWayModal;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    [self.view addSubview:self.shadow];
    [self.view addSubview:self.container];
    [self.container addSubview:self.item];
    [self.container addSubview:self.currentTime];
    [self.container addSubview:self.line];
    [self.container addSubview:self.segment];
    [self.container addSubview:self.datePicker];
    
    [self.shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(kScreenHeight * 3 / 5);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.shadow.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentTime.mas_centerY);
        make.left.equalTo(self.container.mas_left).offset(marginEight);
    }];
    [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container.mas_top).offset(marginEight);
        make.centerX.equalTo(self.container.mas_centerX);
        make.height.mas_equalTo(25);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentTime.mas_bottom).offset(marginEight);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.container.mas_left);
        make.right.equalTo(self.container.mas_right);
    }];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container.mas_centerX);
        make.width.mas_equalTo(kScreenWidth * 0.6);
        make.top.equalTo(self.line.mas_bottom).offset(marginEight);
        make.height.mas_equalTo(30);
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom).offset(marginEight);
        make.left.equalTo(self.container.mas_left);
        make.right.equalTo(self.container.mas_right);
        make.bottom.equalTo(self.container.mas_bottom).offset(-marginEight);
    }];
    
}

#pragma mark - 私有方法
- (NSString *)currentTimeString{
    /// 返回当前时间 格式 yyyy/MM/dd HH:mm
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [self dateFormat];
    return [formatter stringFromDate:dateNow];
}
- (NSString *)timeStringWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}
- (NSString *)dateFormat{
    return @"yyyy-MM-dd HH:mm:ss";
}

#pragma mark - getter & lazy load
- (UIButton *)shadow{
    if (!_shadow) {
        _shadow = UIButton.new;
        [_shadow addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadow;
}
- (UIView *)container{
    if (!_container) {
        _container = UIView.new;
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}
- (UILabel *)item{
    if (!_item) {
        _item = UILabel.new;
        _item.textColor = [UIColor EDJColor_0984e3];
        _item.font = [UIFont systemFontOfSize:15];
        _item.text = @"当前时间";
    }
    return _item;
}
- (UILabel *)currentTime{
    if (!_currentTime) {
        _currentTime = UILabel.new;
        _currentTime.textColor = [UIColor EDJGrayscale_11];
        _currentTime.font = [UIFont systemFontOfSize:15];
        _currentTime.text = [self currentTimeString];
    }
    return _currentTime;
}
- (UIView *)line{
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = [UIColor EDJGrayscale_F3];
    }
    return _line;
}
- (UISegmentedControl *)segment{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"日期",@"时间"]];
        _segment.tintColor = [UIColor EDJGrayscale_66];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = UIDatePicker.new;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        // TODO:Zup_添加时间限定
        if (_lastMonth) { // 是否需要限定最小值
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *currentDate = [NSDate date]; // 当前时间
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setMonth:-1]; // 一个月前
            NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
            _datePicker.minimumDate = minDate;
            _datePicker.maximumDate = currentDate;
        }
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}



@end
