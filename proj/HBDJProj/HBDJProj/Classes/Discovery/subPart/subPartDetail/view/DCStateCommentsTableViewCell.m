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
    _content.text = model.comment;
    _nick.text = model.username;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:DJHeadIconPImage];
    
    if (model.createdtime.length > length_timeString) {
        _time.text = [model.createdtime substringToIndex:length_timeString + 1];
    }else{
        _time.text = model.createdtime;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_icon cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_icon.height * 0.5];
}


@end
