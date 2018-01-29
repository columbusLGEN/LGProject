//
//  UIVCRFooterRV.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIVCRFooterRV.h"

@interface UIVCRFooterRV ()

@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UILabel *lblPayNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDescPayNum;

@end

@implementation UIVCRFooterRV

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self updateSystemLanguage];
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self updateSystemLanguage];
    }];
    _lblDescPayNum.hidden = YES;
    _lblPayNum.hidden = YES;
}

- (void)updateSystemLanguage
{
    _lblDescPayNum.text = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"支付")];
    _lblDescPayNum.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescPayNum.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblDescribe.textColor = [UIColor cm_blackColor_666666_1];
    _lblDescribe.font = [UIFont systemFontOfSize:cFontSize_14];
    
    _lblPayNum.textColor = [UIColor cm_orangeColor_FF5910_1];
    _lblPayNum.font = [UIFont systemFontOfSize:cFontSize_12];
    
    _btnPay.layer.masksToBounds = YES;
    _btnPay.layer.cornerRadius = _btnPay.height/2;
    
    [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPay setTitle:LOCALIZATION(@"立即支付") forState:UIControlStateNormal];
    [_btnPay setBackgroundColor:[UIColor cm_mainColor]];
}

- (void)setPayNum:(CGFloat)payNum
{
    _lblPayNum.hidden = NO;
    _lblDescPayNum.hidden = NO;
    NSString *price = [NSString stringWithFormat:@"%@%.2f", @"¥", payNum];
    NSMutableAttributedString *money = [[NSMutableAttributedString alloc] initWithString:price];
    NSRange upRang = NSMakeRange(1, price.length - 1);
    [money addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.f] range:upRang];
    _lblPayNum.attributedText = money;

    _lblDescribe.text = [NSString stringWithFormat:@"%@: ¥1 = %.2f %@", LOCALIZATION(@"支付比例"), _foreign ? 1/_scoreRate.foreignrate.floatValue : 1/_scoreRate.domesticrate.floatValue, LOCALIZATION(@"虚拟币")];
    _lblDescribe.hidden = _payPurpose == ENUM_PayPurposeAllLease;
}

- (IBAction)click_btnPay:(id)sender {
    if ([self.delegate respondsToSelector:@selector(payWithMoney)] ) {
        [self.delegate payWithMoney];
    }
}

@end
