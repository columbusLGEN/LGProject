//
//  EDJMicroBuildThreeImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroBuildThreeImgCell.h"
#import "EDJMicroBuildModel.h"

@interface EDJMicroBuildThreeImgCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;


@end

@implementation EDJMicroBuildThreeImgCell

@synthesize model = _model;

- (void)setModel:(EDJMicroBuildModel *)model{
    _model = model;
    _title.text = model.title;
    [_img1 sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:DJPlaceholderImage];
    [_img2 sd_setImageWithURL:[NSURL URLWithString:model.imgs[1]] placeholderImage:DJPlaceholderImage];
    [_img3 sd_setImageWithURL:[NSURL URLWithString:model.imgs[2]] placeholderImage:DJPlaceholderImage];
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
