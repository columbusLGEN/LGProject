//
//  UIVCRBottomCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIVCRSelectPriceCollectionViewCell.h"

@interface UIVCRSelectPriceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblLeaseNum;
@property (weak, nonatomic) IBOutlet UILabel *lblRechargeNum;
@property (weak, nonatomic) IBOutlet UILabel *lblGiveNum;
@property (weak, nonatomic) IBOutlet UILabel *lblVirtualCurrency;
@property (weak, nonatomic) IBOutlet UILabel *lblDescVirtualC;

@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (weak, nonatomic) IBOutlet UIImageView *imgPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgBotPrice;

@end


@implementation UIVCRSelectPriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lblRechargeNum.textColor     = [UIColor cm_blackColor_666666_1];
    _lblLeaseNum.textColor        = [UIColor cm_mainColor];
    _lblVirtualCurrency.textColor = [UIColor cm_mainColor];
    _lblDescVirtualC.textColor    = [UIColor cm_blackColor_333333_1];
    _lblGiveNum.textColor         = [UIColor cm_blackColor_333333_1];
    
    _lblRechargeNum.font     = [UIFont systemFontOfSize:cFontSize_16];
    _lblLeaseNum.font        = [UIFont systemFontOfSize:cFontSize_16];
    _lblGiveNum.font         = [UIFont systemFontOfSize:cFontSize_14];
    _lblDescVirtualC.font    = [UIFont systemFontOfSize:cFontSize_14];
    _lblVirtualCurrency.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _viewBackground.layer.borderWidth = 1.f;
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    
    _imgPrice.image    = [UIImage imageNamed:@"icon_virtual_currency"];
    _imgTopPrice.image = [UIImage imageNamed:@"icon_virtual_currency"];
    _imgBotPrice.image = [UIImage imageNamed:@"icon_virtual_currency"];
}

- (void)setIsSelected:(BOOL)isSelected
{
    CGColorRef color = isSelected ? [UIColor cm_mainColor].CGColor : [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderColor = color;
}

- (void)dataDidChange
{
    PayPriceModel *price = self.data;
    
    if (_payPurpose == ENUM_PayPurposeAllLease) {
        _lblLeaseNum.text      = [NSString stringWithFormat:@"%@ %.2f \n %ld %@", @"¥", !_foreign ? price.domesticPrice : price.foreignPrice, price.day, LOCALIZATION(@"天")];
        _lblRechargeNum.hidden = YES;
        _lblGiveNum.hidden     = YES;
        _imgPrice.hidden       = YES;
        _imgTopPrice.hidden    = YES;
        _imgBotPrice.hidden    = YES;
        _lblDescVirtualC.hidden    = YES;
        _lblVirtualCurrency.hidden = YES;
    }
    else {  // 包月
        if (_isSelectedPriceView) {
            _lblLeaseNum.text      = [NSString stringWithFormat:@"%.2f / %ld %@", price.price, price.day, LOCALIZATION(@"天")];
            _lblRechargeNum.hidden = YES;
            _lblGiveNum.hidden     = YES;
            _imgTopPrice.hidden    = YES;
            _imgBotPrice.hidden    = YES;
            _lblDescVirtualC.hidden    = YES;
            _lblVirtualCurrency.hidden = YES;
        }
        else {// 充值
            _lblRechargeNum.text = [NSString stringWithFormat:@"%@ %.2f", @"¥", !_foreign ? price.domesticPrice : price.foreignPrice];
            _lblVirtualCurrency.text = [NSString stringWithFormat:@"%.2f", price.virtualcoinSum];
            _lblGiveNum.text     = [NSString stringWithFormat:@"%@", LOCALIZATION(@"赠送")];
            _lblDescVirtualC.text = [NSString stringWithFormat:@"%.2f", price.presenterSum];
            _lblDescVirtualC.hidden = price.presenterSum == 0;
            _imgBotPrice.hidden  = price.presenterSum == 0;
            _lblGiveNum.hidden   = price.presenterSum == 0;
            _lblLeaseNum.hidden  = YES;
            _imgPrice.hidden     = YES;
        }
    }
}

@end
