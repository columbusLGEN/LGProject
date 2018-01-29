//
//  USCPasswordTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "USCPasswordTableViewCell.h"

@interface USCPasswordTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewline;
@property (weak, nonatomic) IBOutlet UIImageView *imgPassword;

@end

@implementation USCPasswordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell
{
    _imgPassword.image = [UIImage imageNamed:@"icon_login_password"];
    _viewline.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _txtfPassword.font = [UIFont systemFontOfSize:cFontSize_16];
    _txtfPassword.secureTextEntry = YES;
}

@end
