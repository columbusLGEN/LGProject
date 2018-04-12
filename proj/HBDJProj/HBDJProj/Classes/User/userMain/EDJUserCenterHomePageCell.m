//
//  EDJUserCenterHomePageCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJUserCenterHomePageCell.h"
#import "EDJUserCenterHomePageModel.h"

@interface EDJUserCenterHomePageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIView *separatLine;


@end

@implementation EDJUserCenterHomePageCell

- (void)setModel:(EDJUserCenterHomePageModel *)model{
    _model = model;
    _icon.image = [UIImage imageNamed:model.iconName];
    _title.text = model.title;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _separatLine.backgroundColor = [UIColor EDJGrayscale_F4];
}

@end
