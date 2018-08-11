//
//  OLMindReportTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLMindReportTableViewCell.h"
#import "DJThemeMeetingsModel.h"

@interface OLMindReportTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UIImageView *img;


@end

@implementation OLMindReportTableViewCell

- (void)setModel:(DJThemeMeetingsModel *)model{
    _model = model;
    _title.text = model.title;
    if (model.date.length > length_timeString_1) {
        _time.text = [model.date substringToIndex:(length_timeString_1 + 1)];
    }else{
        _time.text = model.date;
    }
    _author.text = [NSString stringWithFormat:@"上传者：%@",model.uploader?model.uploader:@""];
    [_img sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



@end
