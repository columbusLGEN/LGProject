//
//  UCImpowerDetailDescribeTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/14.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCImpowerDetailDescribeTableViewCell.h"

@interface UCImpowerDetailDescribeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;
@property (weak, nonatomic) IBOutlet UILabel *lblImpowerTime;

@property (weak, nonatomic) IBOutlet UIView *verLine;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@end

@implementation UCImpowerDetailDescribeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configDescribeCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configDescribeCell
{
    _lblDescribe.textColor = [UIColor cm_blackColor_666666_1];
    _lblDescribe.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _verLine.backgroundColor = [UIColor cm_mainColor];
    
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = 1.f;
    
    _lblImpowerTime.textColor = [UIColor cm_blackColor_333333_1];
    _lblImpowerTime.font = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)dataDidChange
{
    ImpowerModel *impower = self.data;
    _lblDescribe.text = impower.content.length > 0 ? impower.content : LOCALIZATION(@"授权描述");
    _lblImpowerTime.text = [NSString stringWithFormat:@"%@: %@ - %@", LOCALIZATION(@"授权周期"), [impower.startTime substringToIndex:10], [impower.endTime substringToIndex:10]];
}

@end
