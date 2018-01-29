//
//  UIVCRTopCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIVCRPayTypeCollectionViewCell.h"

@interface UIVCRPayTypeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblRechargeType;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@end

@implementation UIVCRPayTypeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgIcon.layer.masksToBounds = YES;
    _imgIcon.layer.cornerRadius = _imgIcon.height/2;
    
    _lblRechargeType.textColor = [UIColor cm_blackColor_666666_1];
    _lblRechargeType.font = [UIFont systemFontOfSize:cFontSize_14];
    
    _viewBackground.layer.borderWidth = 1.f;
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
}

- (void)setIsSelected:(BOOL)isSelected
{
    CGColorRef color = isSelected ? [UIColor cm_mainColor].CGColor : [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderColor = color;
}

- (void)dataDidChange
{
    PayTypeModel *payType = self.data;
    _lblRechargeType.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? payType.payType : payType.en_paytype;
    NSString *string = @"";
    if ([payType.en_paytype isEqualToString:@"AliPay"]) {
        string = @"icon_aliPay";
    }
    else if ([payType.en_paytype isEqualToString:@"WeChatPay"]) {
        string = @"icon_login_wechat";
    }
    else {
        string = @"icon_applePay";
    }
    _imgIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", string]];
}

@end
