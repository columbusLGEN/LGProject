//
//  UCSettingTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCSettingTableViewCell.h"
#import "UCSettingModel.h"

@interface UCSettingTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemName;


@end

@implementation UCSettingTableViewCell

- (void)setModel:(UCSettingModel *)model{
    _model = model;
    _itemName.text = model.itemName;
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
