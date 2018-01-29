//
//  ZPickView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ZPickView.h"

static id instance = nil;

@implementation ZPickView

/**
 *  配置初始界面
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource selected:(NSInteger)selected;
{
    self = [super init];
    if (self) {
        self = [ZPickView loadFromNibWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
//        _btnSure.hidden = YES;
        
        _arrData = dataSource;
        _selectedIndex = selected;
    }
    return self;
}

- (void)updateSystemLanguage
{
    [_btnSure setTitle:LOCALIZATION(@"确定") forState:UIControlStateNormal];
    [_btnCancel setTitle:LOCALIZATION(@"取消") forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arrData.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([_arrData[row] isKindOfClass:[NSString class]]) {
        return _arrData[row];
    }
    else if ([_arrData[row] isKindOfClass:[UserModel class]]) {
        UserModel *user = _arrData[row];
        return user.name;
    }
    else if ([_arrData[row] isKindOfClass:[ClassModel class]]) {
        ClassModel *classInfo = _arrData[row];
        return classInfo.className;
    }
    else {
        NSNumber *num =  _arrData[row];
        return [NSString stringWithFormat:@"%@", num];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    _btnSure.hidden = NO;
    _selectedIndex = row;
}

#pragma mark -

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
//    if ([self showing]) {
//        return;
//    }
    
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    UIWindow *window =  [windows lastObject];
//    [window addSubview:self];
    
    self.top = Screen_Height;
    [UIView animateWithDuration:cAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        _btnSure.hidden = YES;
        self.top = 0;// self.top - self.height;
    } completion:^(BOOL finished) {
        //        if (finished) {
        //            window.rootViewController.view.userInteractionEnabled = NO;
        //        }
    }];
}
/**
 *  隐藏选择器
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

- (IBAction)click_btnSure:(id)sender {
    [self.delegates ZPickerView:self makeSureIndex:_selectedIndex];
}
- (IBAction)click_btnCancel:(id)sender {
    [self.delegates ZPickerViewCancel:self];
}

@end
