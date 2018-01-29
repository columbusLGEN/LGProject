//
//  USPhoneTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "USPhoneTableViewCell.h"

@interface USPhoneTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgAccount;

@end

@implementation USPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateSystemLanguage
{
    _txtfAccount.placeholder = LOCALIZATION(@"请输入手机号");
    _txtfAreacode.placeholder = LOCALIZATION(@"国家码");
}

- (void)configView
{
    _imgAccount.image = [UIImage imageNamed:@"icon_register_account"];
    _leftLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _rightLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _txtfAccount.textColor  = [UIColor cm_blackColor_333333_1];
    _txtfAreacode.textColor = [UIColor cm_blackColor_333333_1];
    
    _txtfAccount.font  = [UIFont systemFontOfSize:cFontSize_16];
    _txtfAreacode.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _txtfAccount.tag  = 100;
    _txtfAreacode.tag = 101;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_txtfAreacode]) {
        if (_isUpdated) {
            self.selectedAreacode();
        }
        return NO;
    }
    return _isUpdated;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_txtfAreacode]) {
        return NO;
    }
    return _isUpdated;
}

- (void)updateAreacodeWithAreacode:(NSString *)areacode
{
    _txtfAreacode.text = [NSString stringWithFormat:@"+%@", areacode];
}

@end
