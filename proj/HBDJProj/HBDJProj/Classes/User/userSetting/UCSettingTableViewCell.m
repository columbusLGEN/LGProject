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
@property (weak, nonatomic) IBOutlet UISwitch *onOff;
@property (weak, nonatomic) IBOutlet UILabel *info;


@end

@implementation UCSettingTableViewCell

- (void)setModel:(UCSettingModel *)model{
    _model = model;
    _itemName.text = model.itemName;
    if (model.contentType) {
        _info.hidden = YES;
    }else{
        _onOff.hidden = YES;
        _info.text = model.content;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _onOff.onTintColor = [UIColor EDJMainColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
