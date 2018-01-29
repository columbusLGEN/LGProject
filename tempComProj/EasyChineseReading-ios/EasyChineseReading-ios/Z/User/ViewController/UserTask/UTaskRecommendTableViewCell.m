//
//  UTaskReadingTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UTaskRecommendTableViewCell.h"

@interface UTaskRecommendTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblRecommendNumber;     // 推荐图书的数量
@property (weak, nonatomic) IBOutlet UILabel *lblRecommendTime;       // 推荐时间
@property (weak, nonatomic) IBOutlet UILabel *lblRecommendDescribe;   // 推荐描述
@property (weak, nonatomic) IBOutlet UIView *viewBackground;          // 背景

@end

@implementation UTaskRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configTaskReadingView];
}

#pragma mark - 配置界面

- (void)configTaskReadingView
{
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = .5f;
    
    _lblRecommendNumber.textColor   = [UIColor cm_blackColor_333333_1];
    _lblRecommendTime.textColor     = [UIColor cm_blackColor_333333_1];
    _lblRecommendDescribe.textColor = [UIColor cm_blackColor_666666_1];
    
    _lblRecommendNumber.font    = [UIFont systemFontOfSize:16.f];
    _lblRecommendTime.font      = [UIFont systemFontOfSize:12.f];
    _lblRecommendDescribe.font  = [UIFont systemFontOfSize:16.f];
}

#pragma mark - 更新数据

- (void)dataDidChange
{
    ReadTaskModel *readTask = self.data;
    _lblRecommendNumber.text    = [NSString stringWithFormat:@"%@: %@ %ld %@", LOCALIZATION(@"推荐图书"), LOCALIZATION(@"共计"), readTask.bookNum, LOCALIZATION(@"册")];
    _lblRecommendTime.text      = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"推荐时间"), readTask.createTime];
    _lblRecommendDescribe.text  = readTask.content;
}

@end
