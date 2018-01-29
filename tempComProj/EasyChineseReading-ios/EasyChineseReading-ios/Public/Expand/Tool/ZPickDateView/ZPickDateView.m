//
//  ZPickDateView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ZPickDateView.h"

static id instance = nil;

@interface ZPickDateView ()
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@end

@implementation ZPickDateView

- (instancetype)initWithFrame:(CGRect)frame getAfterDate:(BOOL)getAfterDate selected:(NSDate *)selectedDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
{
    self = [super init];
    if (self) {
        self = [ZPickDateView loadFromNibWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];

        //1.获取当前时间时区
        NSDate *date = [NSDate date];
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        //2.获得0时区时间到当前时间的时间差seconds
//        NSTimeInterval seconds = [zone secondsFromGMTForDate:date];
//        //3.将date的时间加上seconds时间即可获得当前时间
//        NSDate *now = [date dateByAddingTimeInterval:seconds];
        
        if (getAfterDate) {
            if (minDate) {
                [_datePickerView setMinimumDate:minDate];
            }
            else {
                [_datePickerView setMinimumDate:date];
            }
            
            if (maxDate) {
                [_datePickerView setMaximumDate:maxDate];
            }
        }
        else {
            [_datePickerView setMaximumDate:date];
        }
        if (selectedDate) {
            [_datePickerView setDate:selectedDate];
        }
        else {
            [_datePickerView setDate:date];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame getAfterDate:(BOOL)getAfterDate selected:(NSDate *)selectedDate
{
    return [self initWithFrame:frame getAfterDate:getAfterDate selected:selectedDate minDate:nil maxDate:nil];
}

/**
 *  配置初始界面
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _datePickerView.datePickerMode = UIDatePickerModeDate;
    _datePickerView.backgroundColor = [UIColor whiteColor];
    _viewBackground.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
}

- (void)updateSystemLanguage
{
    [_btnSure setTitle:LOCALIZATION(@"确定") forState:UIControlStateNormal];
    [_btnCancel setTitle:LOCALIZATION(@"取消") forState:UIControlStateNormal];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    if (view == self) {
        [self hidden];
    }
}

/**
 *  是否弹出日期选择器
 */
- (BOOL)showing
{
    return (self.superview != nil);
}

/**
 *  弹出日期选择器
 */
- (void)show
{
    self.top = Screen_Height;
    [UIView animateWithDuration:cAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.top = 0;//self.top - self.height;
    } completion:^(BOOL finished) {
//        if (finished) {
//            window.rootViewController.view.userInteractionEnabled = NO;
//        }
    }];
}
/**
 *  隐藏日期选择器
 */
- (void)hidden
{
//    UIWindow *window = [AppDelegate sharedInstance].window;
    [UIView animateWithDuration:cAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.top = self.top + self.height;
    } completion:^(BOOL finished){
//        if (finished) {
//        [self removeFromSuperview];
//            window.rootViewController.view.userInteractionEnabled = YES;
//        }
    }];
}

/**
 *  时间
 *
 *  @return 日期选择器上的时间
 */
- (NSDate *)date
{
    // 转中国时间
    //1.初始化一个对象zone，获得0时区时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //2.获得0时区时间到当前时间的时间差seconds
    NSTimeInterval seconds = [zone secondsFromGMTForDate:_datePickerView.date];
    //3.将date1的时间加上seconds时间即可获得当前时间
    NSDate *chinaDate = [_datePickerView.date dateByAddingTimeInterval:seconds];

    return chinaDate;
}

- (IBAction)click_btnSure:(id)sender {
    if ([self.delegete respondsToSelector:@selector(datePickerView:selectedDate:)]) {
        [self.delegete datePickerView:self selectedDate:[self date]];
    }
}
- (IBAction)click_btnCancel:(id)sender {
    if ([self.delegete respondsToSelector:@selector(datePickerViewCancel:)]) {
        [self.delegete datePickerViewCancel:self];
    }
}

@end
