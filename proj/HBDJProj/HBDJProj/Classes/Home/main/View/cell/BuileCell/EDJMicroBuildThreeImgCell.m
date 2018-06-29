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
@property (weak, nonatomic) IBOutlet UILabel *toTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopWidth;


@end

@implementation EDJMicroBuildThreeImgCell

@synthesize model = _model;

- (void)setModel:(EDJMicroBuildModel *)model{
    _model = model;
    _title.text = model.title;
    [_img1 sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:DJPlaceholderImage];
    [_img2 sd_setImageWithURL:[NSURL URLWithString:model.imgs[1]] placeholderImage:DJPlaceholderImage];
    [_img3 sd_setImageWithURL:[NSURL URLWithString:model.imgs[2]] placeholderImage:DJPlaceholderImage];
    if (model.sort != 0) {
        _toTopWidth.constant = 0;
    }else{
        _toTopWidth.constant = 40;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_toTop cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_toTop.height * 0.5];
}

@end
