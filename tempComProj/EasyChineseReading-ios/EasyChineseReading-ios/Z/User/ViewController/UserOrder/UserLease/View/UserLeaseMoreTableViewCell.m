//
//  UserLeaseMoreTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/16.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserLeaseMoreTableViewCell.h"

@interface UserLeaseMoreTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblMore;
@property (weak, nonatomic) IBOutlet UIView *viewBotLine;

@end

@implementation UserLeaseMoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lblMore.textColor = [UIColor cm_blackColor_333333_1];
    _lblMore.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblMore.text = LOCALIZATION(@"加载更多");
    
    _viewBotLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
