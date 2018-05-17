//
//  DCStateCommentsTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCStateCommentsTableViewCell.h"
#import "DCStateCommentsModel.h"

@interface DCStateCommentsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;


@end

@implementation DCStateCommentsTableViewCell

- (void)setModel:(DCStateCommentsModel *)model{
    _model = model;
    _content.text = model.content;
    _nick.text = model.nick;
    
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
