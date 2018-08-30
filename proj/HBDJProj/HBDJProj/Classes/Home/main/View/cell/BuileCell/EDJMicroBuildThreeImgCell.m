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
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingConstraint;


@end

@implementation EDJMicroBuildThreeImgCell

@synthesize model = _model;

- (void)setModel:(EDJMicroBuildModel *)model{
    _model = model;
    _title.text = model.title;
    _sourceLabel.text = model.source;
    [_img1 sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]] placeholderImage:DJPlaceholderImage];
    [_img2 sd_setImageWithURL:[NSURL URLWithString:model.imgs[1]] placeholderImage:DJPlaceholderImage];
    [_img3 sd_setImageWithURL:[NSURL URLWithString:model.imgs[2]] placeholderImage:DJPlaceholderImage];
    if (model.sort == 0) {
        _toTopWidth.constant = 0;
    }else{
        _toTopWidth.constant = 40;
    }
}

- (void)setCollectModel:(DJUcMyCollectModel *)collectModel{
    [super setCollectModel:collectModel];
    
    _title.text = collectModel.title;
    _sourceLabel.text = collectModel.source;
    
    if (collectModel.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.title.mas_top).offset(3);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        self.seButon.selected = collectModel.select;
        _titleLeadingConstraint.constant = 30;
        
    }else{
        [self.seButon removeFromSuperview];
        _titleLeadingConstraint.constant = 5;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_toTop cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_toTop.height * 0.5];
}

@end
