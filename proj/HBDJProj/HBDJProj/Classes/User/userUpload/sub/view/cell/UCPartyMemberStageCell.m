//
//  UCPartyMemberStageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPartyMemberStageCell.h"
#import "UCPartyMemberStageModel.h"

@interface UCPartyMemberStageCell ()
/// ---------------------three img---------------------
@property (weak, nonatomic) IBOutlet UILabel *tiCellUserName;
@property (weak, nonatomic) IBOutlet UILabel *tiCellContent;
@property (weak, nonatomic) IBOutlet UIImageView *tiCellImgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *tiCellImgMid;
@property (weak, nonatomic) IBOutlet UIImageView *tiCellImgRight;
@property (weak, nonatomic) IBOutlet UILabel *tiCellTime;
/// ---------------------three img---------------------
/** 编辑状态，选中展示按钮 */
@property (weak, nonatomic) IBOutlet UIButton *editSelectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftConstraint;


@end

@implementation UCPartyMemberStageCell

/// ---------------------three img---------------------
- (IBAction)tiCellShareClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}

- (IBAction)tiCellCollectClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}
/// ---------------------three img---------------------


- (void)setModel:(UCPartyMemberStageModel *)model{
    _model = model;
    if (model.state == PartyMemberModelStateDefault) {
        /// 默认状态
        _editSelectButton.hidden = YES;
        _nameLeftConstraint.constant = 20;
    }else if (model.state == PartyMemberModelStateEditNormal){
        /// 编辑常规状态
        _editSelectButton.hidden = NO;
        _nameLeftConstraint.constant = 40;
        _editSelectButton.selected = NO;
    }else{
        /// 编辑选中状态
        _editSelectButton.hidden = NO;
        _nameLeftConstraint.constant = 40;
        _editSelectButton.selected = YES;
    }
}
- (void)setupUI{
    _editSelectButton.hidden = YES;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
+ (NSString *)cellReuseIdWithModel:(UCPartyMemberStageModel *)model{
    if (model.imgCount == 1) {
        
    }
    if (model.imgCount == 2) {
        
    }
    if (model.imgCount == 3) {
        return @"UCPartyMemberStageCellThreeImg";
    }
    return nil;
}

@end
