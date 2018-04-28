//
//  DCSubPartStateThreeImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateThreeImgCell.h"

@interface DCSubPartStateThreeImgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *midImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;


@end

@implementation DCSubPartStateThreeImgCell

- (void)setModel:(DCSubPartStateModel *)model{
//    _title.text = model
    UIImage *testImg = [UIImage imageNamed:@"party_history"];
    [_leftImg setImage:testImg];
    [_midImg setImage:testImg];
    [_rightImg setImage:testImg];
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
