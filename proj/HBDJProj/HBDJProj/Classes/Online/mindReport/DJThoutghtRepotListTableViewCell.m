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
    _time.text = model.time;
    _author.text = model.author;
//    _image sd_setImageWithURL:<#(nullable NSURL *)#> placeholderImage:<#(nullable UIImage *)#>
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

@end
