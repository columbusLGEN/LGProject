//
//  UCStudentListTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCStudentListTableViewCell.h"


@interface UCStudentListTableViewCell () 

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel  *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@property (strong, nonatomic) UserModel *user;

@end

@implementation UCStudentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configCell
{
    [_btnEdit setImage:[UIImage imageNamed:@"icon_class_edit"] forState:UIControlStateNormal];
    [_btnDelete setImage:[UIImage imageNamed:@"icon_trash"] forState:UIControlStateNormal];
    
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    
    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth = 3.f;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = .3f;
    _viewShadow.layer.shadowRadius  = 1.f;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _lblName.textColor = [UIColor cm_blackColor_333333_1];
    _lblName.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _imgAvatar.image = [UIImage imageNamed:@"img_avatar_placeholder"];
}

- (void)dataDidChange
{
    _user = self.data;
    _lblName.text = _user.name;
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_user.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
}

- (IBAction)click_btnEdit:(id)sender {
    self.updateSelectedUser(self.data);
}

- (IBAction)click_btnDelete:(id)sender {
    self.deleteSelectedUser(self.data);
}

@end
