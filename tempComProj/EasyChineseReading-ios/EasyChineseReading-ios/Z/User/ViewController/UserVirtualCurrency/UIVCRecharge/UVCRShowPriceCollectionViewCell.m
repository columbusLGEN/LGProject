//
//  UVCRShowPriceCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UVCRShowPriceCollectionViewCell.h"

@interface UVCRShowPriceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@end

@implementation UVCRShowPriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
}

- (void)updateSystemLanguage
{
    _lblDescPrice.textColor = [UIColor cm_blackColor_333333_1];
    _lblCurrency.textColor  = [UIColor cm_blackColor_333333_1];
    _lblPrice.textColor     = [UIColor cm_orangeColor_FF5910_1];
    
    _lblDescPrice.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblPrice.font          = [UIFont systemFontOfSize:cFontSize_14];
    _lblCurrency.font       = [UIFont systemFontOfSize:cFontSize_14];
}

- (void)dataDidChange
{
    OrderModel *order = self.data;
    _lblDescPrice.text = _index == 0 ? LOCALIZATION(@"当前余额") : LOCALIZATION(@"还需支付");
    CGFloat has = [UserRequest sharedInstance].user.virtualCurrency;
    CGFloat pay = order.finalTotalMoney - [UserRequest sharedInstance].user.virtualCurrency >= 0 ? order.finalTotalMoney - [UserRequest sharedInstance].user.virtualCurrency : 0;
    _lblPrice.text     = [NSString stringWithFormat:@"%.2f", _index == 0 ? has : pay];
    _lblCurrency.text  = LOCALIZATION(@" ");
}

@end
