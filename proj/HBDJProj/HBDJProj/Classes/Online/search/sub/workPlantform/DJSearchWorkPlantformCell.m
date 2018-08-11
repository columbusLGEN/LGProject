//
//  DJSearchWorkPlantformCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSearchWorkPlantformCell.h"
#import "DJSearchWorkPlantformModel.h"

@interface DJSearchWorkPlantformCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *uploader;
@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end

@implementation DJSearchWorkPlantformCell

- (void)setModel:(DJSearchWorkPlantformModel *)model{
    _model = model;
//    _title.text = model.title;
//    _time.text = model.createdtime;
//    _uploader.text = model.uploader;
    
//    [_icon sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
