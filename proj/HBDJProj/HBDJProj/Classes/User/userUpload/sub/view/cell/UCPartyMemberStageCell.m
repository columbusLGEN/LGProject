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
- (void)setModel:(UCPartyMemberStageModel *)model{
    _model = model;
}
- (void)setupUI{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}


@end
