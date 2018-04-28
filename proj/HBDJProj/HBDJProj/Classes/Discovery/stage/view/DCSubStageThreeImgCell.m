//
//  DCSubStageThreeImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageThreeImgCell.h"
#import "DCSubStageModel.h"
@interface DCSubStageThreeImgCell ()
@property (strong,nonatomic) DCSubStageModel *subModel;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *midImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@end

@implementation DCSubStageThreeImgCell

- (void)setModel:(DCSubStageModel *)model{
    _subModel = model;
    UIImage *testImg = [UIImage imageNamed:@"party_history"];
    [_leftImg setImage:testImg];
    [_midImg setImage:testImg];
    [_rightImg setImage:testImg];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



@end
