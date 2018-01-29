//
//  UClassRecommendTC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UClassRecommendTableViewCell.h"

@interface UClassRecommendTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblRecommendNumber;       // 推荐图书的数量
@property (weak, nonatomic) IBOutlet UILabel *lblRecommendTime;         // 推荐图书时间
@property (weak, nonatomic) IBOutlet UILabel *lblRecommendDescribe;     // 推荐图书描述
@property (weak, nonatomic) IBOutlet UIView  *viewBackground;           // 背景（阴影线）

@end
@implementation UClassRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configRecommendCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - 配置界面

- (void)configRecommendCell
{
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = .5f;
    
    _lblRecommendNumber.textColor   = [UIColor cm_blackColor_333333_1];
    _lblRecommendTime.textColor     = [UIColor cm_blackColor_333333_1];
    _lblRecommendDescribe.textColor = [UIColor cm_grayColor__807F7F_1];
    
    _lblRecommendNumber.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblRecommendTime.font      = [UIFont systemFontOfSize:cFontSize_12];
    _lblRecommendDescribe.font  = [UIFont systemFontOfSize:cFontSize_14];
}

#pragma mark - 更新数据

- (void)dataDidChange
{
    RecommendModel *recommend  = self.data;
    _lblRecommendNumber.text   = [NSString stringWithFormat:@"%@: %@ %ld %@", LOCALIZATION(@"推荐阅读"), LOCALIZATION(@"共计"), recommend.bookNum, LOCALIZATION(@"本")];
    _lblRecommendTime.text     = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"推荐时间"), recommend.createTime];
    _lblRecommendDescribe.text = recommend.content;
}

@end
