//
//  EDJMicroBuildNoImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroBuildNoImgCell.h"
#import "EDJMicroBuildModel.h"

@interface EDJMicroBuildNoImgCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sub_title;
@property (weak, nonatomic) IBOutlet UILabel *toTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingConstraint;

@end

@implementation EDJMicroBuildNoImgCell

@synthesize model = _model;
- (void)setModel:(EDJMicroBuildModel *)model{
    _model = model;
    _title.text = model.title;
    _sub_title.text = model.source;
    
    if (model.sort == 0) {
        _toTopWidth.constant = 0;
    }else{
        _toTopWidth.constant = 40;
    }
}

- (void)setCollectModel:(DJUcMyCollectModel *)collectModel{
    [super setCollectModel:collectModel];
    
    _title.text = collectModel.title;
    _sub_title.text = collectModel.source;
    
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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_toTop cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_toTop.height * 0.5];
}

@end
