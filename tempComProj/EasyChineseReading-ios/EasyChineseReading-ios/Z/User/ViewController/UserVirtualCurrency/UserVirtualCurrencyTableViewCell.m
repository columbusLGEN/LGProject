//
//  UVirtualCurrencyTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserVirtualCurrencyTableViewCell.h"

@interface UserVirtualCurrencyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;            // 描述
@property (weak, nonatomic) IBOutlet UILabel *lblVirtualCurrent;      // 虚拟币
@property (weak, nonatomic) IBOutlet UILabel *lblVirtualCurrentTime;  // 时间

@end

@implementation UserVirtualCurrencyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configVirtualCurrent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configVirtualCurrent
{
    _viewBackground.layer.borderWidth = .5f;
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    
    _lblDescribe.textColor           = [UIColor cm_blackColor_333333_1];
    _lblVirtualCurrent.textColor     = [UIColor cm_blackColor_333333_1];
    _lblVirtualCurrentTime.textColor = [UIColor cm_blackColor_666666_1];
    
    _lblDescribe.font           = [UIFont systemFontOfSize:16.f];
    _lblVirtualCurrent.font     = [UIFont systemFontOfSize:16.f];
    _lblVirtualCurrentTime.font = [UIFont systemFontOfSize:14.f];
}

#pragma mark -

- (void)dataDidChange
{
    VirtualCurrencyModel *integral = self.data;
    
    NSMutableAttributedString *virtural = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", integral.money, LOCALIZATION(@"虚拟币")]];
    //获取要调整颜色的文字位置,调整颜色 
    NSRange range = [[virtural string] rangeOfString:@" "];
    [virtural addAttribute:NSForegroundColorAttributeName value:[UIColor cm_mainColor] range:NSMakeRange(0, range.location)];
    [virtural addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:NSMakeRange(0, range.location)];
    
    _lblVirtualCurrent.attributedText = virtural;
    switch (integral.type) {
        case ENUM_IntegralTypeCost:
            _lblDescribe.text = [NSString stringWithFormat:@"%@ ", LOCALIZATION(@"消费")];
            break;
        case ENUM_IntegralTypeGet:
            _lblDescribe.text = [NSString stringWithFormat:@"%@ ", LOCALIZATION(@"充值")];
            break;
        case ENUM_IntegralTypeGive:
            _lblDescribe.text = [NSString stringWithFormat:@"%@ ", LOCALIZATION(@"赠送")];
            break;
        case ENUM_IntegralTypeTicket:
            _lblDescribe.text = [NSString stringWithFormat:@"%@ ", LOCALIZATION(@"充值券充值")];
            break;
        default:
            break;
    }
    _lblVirtualCurrentTime.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"更新日期"), integral.time];
}

@end
