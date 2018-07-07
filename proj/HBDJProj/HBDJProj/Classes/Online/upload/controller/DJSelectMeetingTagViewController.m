//
//  DJSelectMeetingTagViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSelectMeetingTagViewController.h"

@interface DJSelectMeetingTagViewController ()<
UIPickerViewDelegate,
UIPickerViewDataSource>
@property (strong,nonatomic) UIButton *shadow;
@property (strong,nonatomic) UIPickerView *tagPicker;
@property (strong,nonatomic) NSArray *array;
@property (assign,nonatomic) CGFloat tagPickerHeight;
@property (strong,nonatomic) NSString *selectString;

@end

@implementation DJSelectMeetingTagViewController

- (void)lg_dismissViewController{
    if ([self.delegate respondsToSelector:@selector(selectMeetingTag:selectString:)]) {
        [self.delegate selectMeetingTag:self selectString:_selectString];
    }
    [super lg_dismissViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushWay = LGBaseViewControllerPushWayModal;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    [self.view addSubview:self.shadow];
    [self.view addSubview:self.tagPicker];
    
    [self.shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.tagPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shadow.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(self.tagPickerHeight);
    }];
    
    self.array = @[@"支部党员大会",
                   @"党支部党员大会",
                   @"党小组会",
                   @"党课",];
    [self.tagPicker reloadAllComponents];
    _selectString = self.array[0];
}



#pragma mark - 代理方法
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.array.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    return self.array[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return _tagPickerHeight / 3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectString = self.array[row];
    
}


- (CGFloat)tagPickerHeight{
    if (_tagPickerHeight == 0) {
        _tagPickerHeight = kScreenHeight / 4;
    }
    return _tagPickerHeight;
}
- (UIPickerView *)tagPicker{
    if (!_tagPicker) {
        _tagPicker = UIPickerView.new;
        _tagPicker.delegate = self;
        _tagPicker.backgroundColor = [UIColor whiteColor];
    }
    return _tagPicker;
}

- (UIButton *)shadow{
    if (!_shadow) {
        _shadow = UIButton.new;
        [_shadow addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadow;
}


@end
