//
//  UCRStudentListTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRStudentListTableViewCell.h"

@interface UCRStudentListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@end

@implementation UCRStudentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configView
{
    _imgSelected.image = [UIImage imageNamed:@"icon_selected_no"];
    _lblNumber.textColor = [UIColor cm_blackColor_333333_1];
    _lblUserName.textColor = [UIColor cm_blackColor_333333_1];
    _lblClassName.textColor = [UIColor cm_blackColor_333333_1];
    
    _lblNumber.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblUserName.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblClassName.font = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)dataDidChange
{
    UserModel *user = self.data;
    
    _lblUserName.text = user.name;
    _lblClassName.text = user.className;
    
    _isSelected = user.isSelected;
    _imgSelected.image = _isSelected ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _imgSelected.image = isSelected ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
}

@end
