//
//  DJThoutghtRepotListTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoutghtRepotListTableViewCell.h"
#import "DJThoutghtRepotListModel.h"

@interface DJThoutghtRepotListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation DJThoutghtRepotListTableViewCell

- (void)setModel:(DJThoutghtRepotListModel *)model{
    _model = model;
    _title.text = model.title;
    if (model.createdtime.length > length_timeString_1) {
        _time.text = [model.createdtime substringToIndex:(length_timeString_1 + 1)];
    }else{
        _time.text = model.createdtime;
    }
    _author.text = model.uploader;
    [_image sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

@end
