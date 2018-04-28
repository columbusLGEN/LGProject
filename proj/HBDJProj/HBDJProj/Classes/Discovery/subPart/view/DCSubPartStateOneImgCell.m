//
//  DCSubPartStateOneImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateOneImgCell.h"

@interface DCSubPartStateOneImgCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *img;


@end

@implementation DCSubPartStateOneImgCell

- (void)setModel:(DCSubPartStateModel *)model{
    UIImage *testImg = [UIImage imageNamed:@"party_history"];
    [_img setImage:testImg];
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
