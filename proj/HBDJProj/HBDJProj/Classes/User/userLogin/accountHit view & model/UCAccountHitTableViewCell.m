//
//  UCAccountHitTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCAccountHitTableViewCell.h"
#import "UCAccountHitModel.h"

@interface UCAccountHitTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextField *txtField;


@end

@implementation UCAccountHitTableViewCell

- (void)setModel:(UCAccountHitModel *)model{
    _model = model;
    _icon.image = [UIImage imageNamed:model.iconName];
    _txtField.placeholder = model.placeholder;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
