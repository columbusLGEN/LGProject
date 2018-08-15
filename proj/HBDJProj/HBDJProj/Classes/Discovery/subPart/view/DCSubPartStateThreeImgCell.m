//
//  DCSubPartStateThreeImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateThreeImgCell.h"
#import "DCSubPartStateModel.h"

@interface DCSubPartStateThreeImgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *midImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;


@end

@implementation DCSubPartStateThreeImgCell

- (void)setModel:(DCSubPartStateModel *)model{
    [super setModel:model];
    _title.text = model.title;
    
    NSURL *url0;
    NSURL *url1;
    NSURL *url2;
    if (model.imgUrls.count > 2) {
        url0 = [NSURL URLWithString:model.imgUrls[0]];
        url1 = [NSURL URLWithString:model.imgUrls[1]];
        url2 = [NSURL URLWithString:model.imgUrls[2]];
    }
    
    [_leftImg sd_setImageWithURL:url0 placeholderImage:DJPlaceholderImage];
    [_midImg sd_setImageWithURL:url1 placeholderImage:DJPlaceholderImage];
    [_rightImg sd_setImageWithURL:url2 placeholderImage:DJPlaceholderImage];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    /// 保证图片的宽高比为 16 : 9 = 1.77
    self.imgHeight.constant = self.leftImg.width / 1.77;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
