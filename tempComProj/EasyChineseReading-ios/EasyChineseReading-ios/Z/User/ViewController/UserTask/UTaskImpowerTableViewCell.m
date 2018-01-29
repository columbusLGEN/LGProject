//
//  UTaskImpowerTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/13.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UTaskImpowerTableViewCell.h"

@interface UTaskImpowerTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblImpowerNumber;       // 推荐图书的数量
@property (weak, nonatomic) IBOutlet UILabel *lblImpowerTime;         // 推荐图书时间
@property (weak, nonatomic) IBOutlet UILabel *lblImpowerDescribe;     // 推荐图书描述
@property (weak, nonatomic) IBOutlet UIView *viewBackground;            // 背景（阴影线）
@property (weak, nonatomic) IBOutlet UILabel *lblImpowerTimeRange;

@end

@implementation UTaskImpowerTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self configImpowerCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    
    _lblImpowerNumber.font    = [UIFont systemFontOfSize:15.f];
    _lblImpowerTime.font      = [UIFont systemFontOfSize:12.f];
    _lblImpowerTimeRange.font = [UIFont systemFontOfSize:12.f];
    _lblImpowerDescribe.font  = [UIFont systemFontOfSize:14.f];
}

#pragma mark - 更新数据

- (void)dataDidChange
{
    ReadTaskModel *readTask = self.data;
    _lblImpowerNumber.text    = [NSString stringWithFormat:@"%@: %@ %ld %@", LOCALIZATION(@"授权图书"), LOCALIZATION(@"共计"), readTask.bookNum, LOCALIZATION(@"册")];
    _lblImpowerTime.text      = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"授权时间"),readTask.startTime];
    
    _lblImpowerTimeRange.text = [NSString stringWithFormat:@"%@: %@ - %@ ", LOCALIZATION(@"授权周期"), readTask.startTime, readTask.endTime];
    _lblImpowerDescribe.text  = readTask.grantbatchContent;
    
//    _lblRecommendNumber.text    = [NSString stringWithFormat:@"%@: %@%@%@", LOCALIZATION(@"推荐图书"), LOCALIZATION(@"共计"),readTask.num, LOCALIZATION(@"册")];
}


@end
