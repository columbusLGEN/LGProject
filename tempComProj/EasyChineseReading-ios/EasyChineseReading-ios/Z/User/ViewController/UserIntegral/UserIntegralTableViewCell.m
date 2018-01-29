//
//  UserIntegralTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserIntegralTableViewCell.h"

@interface UserIntegralTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView  *viewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;    // 积分来源与去向
@property (weak, nonatomic) IBOutlet UILabel *lblIntegralTime;// 更新时间
@property (weak, nonatomic) IBOutlet UILabel *lblIntegral;    // 积分数

@end

@implementation UserIntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configIntegralView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configIntegralView
{
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = .5f;
    
    _lblDescribe.textColor      = [UIColor cm_blackColor_333333_1];
    _lblIntegralTime.textColor  = [UIColor cm_blackColor_666666_1];
    _lblIntegral.textColor      = [UIColor cm_mainColor];
    
    _lblDescribe.font       = [UIFont systemFontOfSize:16.f];
    _lblIntegral.font       = [UIFont systemFontOfSize:16.f];
    _lblIntegralTime.font   = [UIFont systemFontOfSize:14.f];
}

#pragma mark -

- (void)dataDidChange
{
    IntegralModel *integral = self.data;
    if (integral.type == ENUM_IntegralTypeGet) {
        _lblIntegral.text = [NSString stringWithFormat:@"+%@", integral.score];
        _lblDescribe.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? integral.soure : integral.en_soure;
    }
    else {
        _lblIntegral.text = [NSString stringWithFormat:@"-%@", integral.score];
        if (integral.soure.length == 0 && integral.en_soure == 0) {
            integral.soure = LOCALIZATION(@"消费");
            _lblDescribe.text = integral.soure;
        }
        else {
            _lblDescribe.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? integral.soure : integral.en_soure;
        }
    }
    _lblIntegralTime.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"更新时间"),integral.time];
}

@end
