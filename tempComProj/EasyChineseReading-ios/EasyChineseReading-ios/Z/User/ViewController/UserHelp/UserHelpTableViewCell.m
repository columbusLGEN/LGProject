//
//  UserHelpTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserHelpTableViewCell.h"

@interface UserHelpTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblQuestion; // 问题
@property (weak, nonatomic) IBOutlet UILabel *lblResponse; // 回答

@end


@implementation UserHelpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configCell
{
    _lblQuestion.textColor = [UIColor cm_blackColor_333333_1];
    _lblResponse.textColor = [UIColor cm_blackColor_666666_1];
    
    _lblQuestion.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblResponse.font = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)dataDidChange
{
    NSDictionary *dic = self.data;
    _lblQuestion.text = dic[@"question"];
    _lblResponse.text = dic[@"response"];
}

@end
