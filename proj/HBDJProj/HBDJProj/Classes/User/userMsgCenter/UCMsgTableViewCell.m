//
//  UCMsgTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMsgTableViewCell.h"
#import "UCMsgModel.h"

@interface UCMsgTableViewCell ()


@end

@implementation UCMsgTableViewCell

- (void)setModel:(UCMsgModel *)model{
    _model = model;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
