//
//  UCMessageListTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCMessageListTableViewCell.h"

@interface UCMessageListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@end

@implementation UCMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblMessage.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblMessage.textColor = [UIColor cm_blackColor_333333_1];
    
    _lblTime.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblTime.textColor = [UIColor cm_blackColor_333333_1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dataDidChange
{
    SendMessageModel *message = self.data;
    _lblMessage.text = message.message;
    _lblTime.text = message.createdTime;
}

@end
