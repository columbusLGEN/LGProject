//
//  UCRecommendDetailDescribeTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendDetailDescribeTableViewCell.h"

@interface UCRecommendDetailDescribeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;
@property (weak, nonatomic) IBOutlet UIView  *viewBackground;

@end

@implementation UCRecommendDetailDescribeTableViewCell

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
    
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = 1.f;
}

- (void)dataDidChange
{
    if (_isMessage) {
        SendMessageModel *message = self.data;
        _lblDescribe.text = message.message;
    }
    else {
        RecommendModel *recommend = self.data;
        _lblDescribe.text = recommend.content.length > 0 ? recommend.content : LOCALIZATION(@"推荐内容");
    }
}

@end
