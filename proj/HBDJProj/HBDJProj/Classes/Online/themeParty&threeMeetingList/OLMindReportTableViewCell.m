//
//  OLMindReportTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLMindReportTableViewCell.h"
#import "OLMindReportModel.h"

@interface OLMindReportTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UIImageView *img;


@end

@implementation OLMindReportTableViewCell

- (void)setModel:(OLMindReportModel *)model{
    _model = model;
    _title.text = model.title;
    _time.text = model.testTime;
    _author.text = [NSString stringWithFormat:@"作者：%@",model.author];
//    _img sd_setImageWithURL:<#(nullable NSURL *)#> placeholderImage:<#(nullable UIImage *)#>
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



@end
