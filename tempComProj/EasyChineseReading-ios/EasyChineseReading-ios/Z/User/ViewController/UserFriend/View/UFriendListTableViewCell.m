//
//  UFriendListNewTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UFriendListTableViewCell.h"

@interface UFriendListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (weak, nonatomic) IBOutlet UIImageView *imgSex;
@property (weak, nonatomic) IBOutlet UIImageView *imgBirthday;
@property (weak, nonatomic) IBOutlet UIImageView *imgCountry;

@property (weak, nonatomic) IBOutlet UILabel *lblInsterest;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;

@property (weak, nonatomic) IBOutlet UIImageView *imgAddFriend;
@property (weak, nonatomic) IBOutlet UILabel *lblAddFriend;

@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (strong, nonatomic) FriendModel *friendInfo;

@end

@implementation UFriendListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCellViewManager];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawRoundedRectPathWithView:_viewBackground];
}

#pragma mark - 配置好友列表界面

- (void)configCellViewManager
{
    self.backgroundColor = [UIColor whiteColor];
    [self configUserAvatar];
    [self configUserInfoView];
    [self configAddFriendButton];
}
// 头像模块
- (void)configUserAvatar
{
    _viewBackground.backgroundColor = [UIColor clearColor];
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    
    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth = 3.f;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = .3f;
    _viewShadow.layer.shadowRadius  = 1.f;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _imgAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFriendInfo)];
    [_imgAvatar addGestureRecognizer:tapAvatar];
    
    _imgAddFriend.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFriendManager = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddFriendButton)];
    [_imgAddFriend addGestureRecognizer:tapFriendManager];
    
    _lblAddFriend.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLblFriendManager = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddFriendButton)];
    [_lblAddFriend addGestureRecognizer:tapLblFriendManager];
}
// 好友信息模块
- (void)configUserInfoView
{
    _lblName.textColor = [UIColor cm_blackColor_333333_1];
    _lblName.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblBirthday.textColor = [UIColor cm_blackColor_666666_1];
    _lblBirthday.font = [UIFont systemFontOfSize:cFontSize_14];
    
    _lblCountry.textColor = [UIColor cm_blackColor_666666_1];
    _lblCountry.font = [UIFont systemFontOfSize:cFontSize_14];
    
    _lblInsterest.textColor = [UIColor cm_blackColor_666666_1];
    _lblInsterest.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblInsterest.text = LOCALIZATION(@"这家伙很懒，什么也没有写");
    
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
}
// 添加及取消好友按键
- (void)configAddFriendButton
{
    _imgAddFriend.image = [UIImage imageNamed:@"icon_friend_added"];
    _lblAddFriend.textColor = [UIColor cm_yellowColor_FFAF04_1];
    _lblAddFriend.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblAddFriend.text = LOCALIZATION(@"加书友");
}

#pragma mark - 数据

- (void)dataDidChange
{
    _imgBirthday.hidden = !isPad;
    _imgCountry.hidden  = !isPad;
    _lblBirthday.hidden = !isPad;
    _lblCountry.hidden  = !isPad;
    
    _friendInfo = self.data;
    
    _lblName.text = _friendInfo.name;
    _lblBirthday.text = _friendInfo.birthday.length > 0 ? _friendInfo.birthday : [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_SelectBirthday];
    _lblCountry.text = _friendInfo.countryName.length > 0 ? _friendInfo.countryName : @"China";
    
    _imgSex.image = _friendInfo.sex == ENUM_SexTypeMan ? [UIImage imageNamed:@"icon_user_friend_boy"] : [UIImage imageNamed:@"icon_user_friend_girl"];
    _imgBirthday.image = [UIImage imageNamed:@"icon_user_friend_birthday"];
    _imgCountry.image = [UIImage imageNamed:@"icon_launch_location"];
    
    _lblInsterest.text = _friendInfo.interest.length > 0 ? _friendInfo.interest : LOCALIZATION(@"这家伙很懒，什么也没有写");
    _lblInsterest.textColor = _friendInfo.interest ? [UIColor cm_blackColor_333333_1] : [UIColor cm_blackColor_666666_1];
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_friendInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    
    NSArray *arrFriendIds = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_FriendIdsList];
    _friendInfo.isFriend = [arrFriendIds containsObject:@(_friendInfo.userId)];
    [self isFriend];
}

#pragma mark - handle

/** 是好友 */
- (void)isFriend
{
    _lblAddFriend.text = _friendInfo.isFriend ? LOCALIZATION(@"取消关注") : LOCALIZATION(@"加书友");
    _imgAddFriend.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _friendInfo.isFriend ? @"icon_friend_added" : @"icon_friend_add"]];
    _lblAddFriend.textColor = _friendInfo.isFriend ? [UIColor cm_blackColor_666666_1] : [UIColor cm_yellowColor_FFAF04_1];
}

- (void)toFriendInfo
{
    if ([self.delegate respondsToSelector:@selector(toFriendInfoWithFriend:)]) {
        [self.delegate toFriendInfoWithFriend:self.data];
    }
}

- (void)tapAddFriendButton
{
    _friendInfo.isFriend = !_friendInfo.isFriend;
    [self isFriend];
    if (_friendInfo.isFriend) {
        [self.delegate addFriendWithFriend:self.data];
    }
    else {
        [self.delegate delFriendWithFriend:self.data];
    }
}

@end
