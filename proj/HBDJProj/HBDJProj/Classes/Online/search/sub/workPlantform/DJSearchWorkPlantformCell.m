//
//  DJSearchWorkPlantformCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSearchWorkPlantformCell.h"
#import "DJThemeMeetingsModel.h"

@interface DJSearchWorkPlantformCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *uploader;
@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end

@implementation DJSearchWorkPlantformCell

- (void)setModel:(DJThemeMeetingsModel *)model{
    _model = model;
    _title.text = model.title;
    if (model.date.length > length_timeString_1) {
        model.date = [model.date substringToIndex:length_timeString_1 + 1];
    }
    _time.text = model.date;
    _uploader.text = [@"上传者: " stringByAppendingString:model.uploader];
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
