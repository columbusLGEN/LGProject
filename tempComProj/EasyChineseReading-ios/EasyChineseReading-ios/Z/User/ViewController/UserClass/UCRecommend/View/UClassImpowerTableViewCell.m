//
//  UClassImpowerTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UClassImpowerTableViewCell.h"

@interface UClassImpowerTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblImpowerNumber;       // 推荐图书的数量
@property (weak, nonatomic) IBOutlet UILabel *lblImpowerTime;         // 推荐图书时间
@property (weak, nonatomic) IBOutlet UILabel *lblImpowerDescribe;     // 推荐图书描述
@property (weak, nonatomic) IBOutlet UILabel *lblImpowerTimeRange;    // 授权时间范围
@property (weak, nonatomic) IBOutlet UIView  *viewBackground;         // 背景（阴影线）

@end

@implementation UClassImpowerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configImpowerCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - 配置界面

- (void)configImpowerCell
{
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = .5f;
    
    _lblImpowerNumber.textColor    = [UIColor cm_blackColor_333333_1];
    _lblImpowerTime.textColor      = [UIColor cm_blackColor_333333_1];
    _lblImpowerTimeRange.textColor = [UIColor cm_blackColor_333333_1];
    _lblImpowerDescribe.textColor  = [UIColor cm_grayColor__807F7F_1];
    
    _lblImpowerNumber.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblImpowerTime.font      = [UIFont systemFontOfSize:cFontSize_12];
    _lblImpowerTimeRange.font = [UIFont systemFontOfSize:cFontSize_12];
    _lblImpowerDescribe.font  = [UIFont systemFontOfSize:cFontSize_14];
}

#pragma mark - 更新数据

- (void)dataDidChange
{
    ImpowerModel *impower  = self.data;
    _lblImpowerNumber.text = [NSString stringWithFormat:@"%@: %@ %ld %@", LOCALIZATION(@"授权阅读"), LOCALIZATION(@"共计"), impower.bookNum, LOCALIZATION(@"本")];
    _lblImpowerTime.text   = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"授权时间"), impower.createTime];
    
    
    impower.startTime = [impower.startTime substringToIndex:10];
    impower.endTime   = [impower.endTime substringToIndex:10];
    _lblImpowerTimeRange.text = [NSString stringWithFormat:@"%@: %@ - %@ ", LOCALIZATION(@"授权周期"), impower.startTime, impower.endTime];
    _lblImpowerDescribe.text  = impower.content;
}


@end
