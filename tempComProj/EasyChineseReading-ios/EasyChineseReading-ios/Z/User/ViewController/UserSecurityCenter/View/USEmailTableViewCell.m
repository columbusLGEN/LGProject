//
//  USEmailTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/7.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "USEmailTableViewCell.h"

@interface USEmailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmail;

@end

@implementation USEmailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateSystemLanguage
{
    _txtfAccount.placeholder = LOCALIZATION(@"请输入邮箱");
}

- (void)configView
{
    _imgEmail.image = [UIImage imageNamed:@"icon_register_email"];
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _txtfAccount.textColor  = [UIColor cm_blackColor_333333_1];
    _txtfAccount.font  = [UIFont systemFontOfSize:cFontSize_16];
    _txtfAccount.tag = 200;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return _isUpdated;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return _isUpdated;
}

@end
