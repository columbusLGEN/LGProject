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
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;


@end

@implementation UCMsgTableViewCell

- (void)setModel:(UCMsgModel *)model{
    _model = model;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


@end
