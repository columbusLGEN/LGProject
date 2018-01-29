//
//  UIVCRHeaderRV.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIVCRHeaderRV.h"

@interface UIVCRHeaderRV ()
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@end

@implementation UIVCRHeaderRV

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
    _verLine.backgroundColor = [UIColor cm_mainColor];
    
    _lblDescribe.textColor = [UIColor cm_blackColor_333333_1];
    _lblPrice.textColor    = [UIColor cm_orangeColor_FF5910_1];
    
    _lblDescribe.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblPrice.font    = [UIFont systemFontOfSize:cFontSize_16];
    
    _imgVC.hidden = YES;
    _lblPrice.hidden = YES;
}
- (void)dataDidChange
{
    NSString *price = self.data;
    
    _imgVC.hidden = !_showPrice;
    _lblPrice.hidden = !_showPrice;
    
    _lblDescribe.text = LOCALIZATION(@"商品共计");
    _lblPrice.text = price;
}

@end
