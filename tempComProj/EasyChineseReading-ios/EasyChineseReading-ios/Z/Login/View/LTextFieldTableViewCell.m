//
//  LTextFieldTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LTextFieldTableViewCell.h"

@interface LTextFieldTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;

@property (strong, nonatomic) NSDictionary *dic;

@end

@implementation LTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _txtfContent.delegate = self;
    _txtfContent.font = [UIFont systemFontOfSize:cFontSize_16];
    if ([IPhoneVersion deviceSize] <= iPhone4inch)
        _txtfContent.font = [UIFont systemFontOfSize:cFontSize_14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dataDidChange {
    _dic = self.data;
    
    BOOL isPassword = _dic[@"password"];
    _imgIcon.image               = [UIImage imageNamed:_dic[@"icon"]];
    _txtfContent.tag             = [_dic[@"index"] integerValue];
    _txtfContent.text            = _dic[@"content"] ? _dic[@"content"] : @"";
    _txtfContent.placeholder     = _dic[@"placeHolder"];
    _imgSelected.hidden          = !_dic[@"showSelected"];
    _txtfContent.secureTextEntry = isPassword;
    _txtfContent.keyboardType    = _dic[@"isEmail"] ? UIKeyboardTypeEmailAddress : UIKeyboardTypeDefault;
    
    if ([_dic[@"index"] isEqualToString:@"20003"] || [_dic[@"index"] isEqualToString:@"20006"])  // 学生数 手机号
        _txtfContent.keyboardType = UIKeyboardTypeNumberPad;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!_imgSelected.hidden) {
        if ([_dic[@"index"] isEqualToString:@"20002"])
            [self.delegate selectedSchoolType];
        else if ([_dic[@"index"] isEqualToString:@"20004"])
            [self.delegate selectedCountry];
        return NO;
    }
    return YES;
}

// 取消第一响应者
- (void)resignAllFirstResponder {
    [_txtfContent resignFirstResponder];
}

@end
