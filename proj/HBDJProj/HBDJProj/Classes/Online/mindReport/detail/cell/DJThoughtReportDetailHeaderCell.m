//
//  DJThoughtReportDetailHeaderCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoughtReportDetailHeaderCell.h"
#import "DJThoughtReportDetailModel.h"

@interface DJThoughtReportDetailHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *uploader;



@end

@implementation DJThoughtReportDetailHeaderCell

- (void)setModel:(DJThoughtReportDetailModel *)model{
    [super setModel:model];
    _title.text = model.title;
    _time.text = model.createdtime;
    _uploader.text = [@"上传者: " stringByAppendingString:model.uploader];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UIColor *color = UIColor.EDJGrayscale_AD;
    _time.textColor = color;
    _uploader.textColor = color;
}

@end
