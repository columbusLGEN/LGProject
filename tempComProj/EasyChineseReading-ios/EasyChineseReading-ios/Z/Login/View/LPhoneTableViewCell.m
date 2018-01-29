//
//  LPhoneTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "LPhoneTableViewCell.h"

@interface LPhoneTableViewCell ()<UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *dic;

@end

@implementation LPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _txtfAccount.delegate  = self;
    _txtfAreaCode.delegate = self;
    _txtfAccount.font  = [UIFont systemFontOfSize:cFontSize_16];
    _txtfAreaCode.font = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dataDidChange {
    _dic = self.data;

    _imgIcon.image            = [UIImage imageNamed:_dic[@"icon"]];
    NSString *placeholder     = _dic[@"placeHolder"];
    _txtfAccount.placeholder  = placeholder.length > 0 ? placeholder : LOCALIZATION(@"手机号");
    _txtfAccount.keyboardType = _dic[@"isPhone"] ? UIKeyboardTypePhonePad : UIKeyboardTypeEmailAddress;
    _txtfAccount.tag          = [_dic[@"index"] integerValue];
    _txtfAreaCode.placeholder = LOCALIZATION(@"国家码");
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtfAreaCode]) {
        self.selectedAreacode();
        return NO;
    }
    return !_cantSelected;
}

// 修改国家码
- (void)updateAreacodeWithAreacode:(NSString *)areacode {
    _txtfAreaCode.text = areacode;
}

// 取消第一响应者
- (void)resignAllFirstResponder {
    [_txtfAccount resignFirstResponder];
}

@end
