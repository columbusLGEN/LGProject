//
//  UCImpowerTeacherTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCImpowerTeacherTableViewCell.h"

@interface UCImpowerTeacherTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@implementation UCImpowerTeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configView
{
    _imgSelected.image = [UIImage imageNamed:@"icon_selected_no"];
    _lblNumber.textColor = [UIColor cm_blackColor_333333_1];
    _lblName.textColor = [UIColor cm_blackColor_333333_1];
    
    _lblNumber.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblName.font = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)dataDidChange
{
    UserModel *user = self.data;
    _lblName.text = user.name;
    _isSelected = user.isSelected;
    _imgSelected.image = _isSelected ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _imgSelected.image = isSelected ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
}

@end
