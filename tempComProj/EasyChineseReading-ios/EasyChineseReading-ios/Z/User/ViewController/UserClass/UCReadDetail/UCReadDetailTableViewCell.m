//
//  UCReadDetailTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCReadDetailTableViewCell.h"

@interface UCReadDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthProgressConstraint;

@end

@implementation UCReadDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configReadDetailView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configReadDetailView
{
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth = 3.f;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = .1f;
    _viewShadow.layer.shadowRadius  = 1.f;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _lblName.textColor = [UIColor cm_blackColor_333333_1];
    _lblPercent.textColor = [UIColor cm_blackColor_333333_1];
    
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = _backView.height/2;
    _backView.layer.borderColor = [UIColor cm_orangeColor_FF5910_1].CGColor;
    _backView.layer.borderWidth = 0.5f;
}

- (void)dataDidChange
{
    FriendModel *student = self.data;
    
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:student.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    _lblName.text = student.name;
    _lblPercent.text = [NSString stringWithFormat:@"%.2f%%", student.readProgress];
    
    UIView *frontView = [UIView new];
    _widthProgressConstraint.constant = Screen_Width - 270;
    // 阅读进度
    CGFloat width = _widthProgressConstraint.constant * student.readProgress / 100;
    frontView.frame = CGRectMake(0, 0, width, _backView.height);
    frontView.backgroundColor = [UIColor cm_orangeColor_FF5910_1];
    [_backView addSubview:frontView];
}

@end
