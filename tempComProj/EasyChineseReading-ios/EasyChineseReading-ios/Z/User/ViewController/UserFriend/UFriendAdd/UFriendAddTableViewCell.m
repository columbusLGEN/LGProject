//
//  UFriendAddTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UFriendAddTableViewCell.h"

@interface UFriendAddTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgAddFriend;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddFriend;

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (strong, nonatomic) FriendModel *friend;

@end

@implementation UFriendAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configAddCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configAddCell
{
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius  = _imgAvatar.height/2;
    
    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth = 3.f;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = 0.1;
    _viewShadow.layer.shadowRadius  = 1;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblUserName.textColor  = [UIColor cm_blackColor_333333_1];
    _lblAddFriend.textColor = [UIColor cm_mainColor];
    
    UITapGestureRecognizer *tapImgFriend = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend)];
    UITapGestureRecognizer *tapLblFriend = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend)];
    UITapGestureRecognizer *tapImgAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFriendInfo)];

    [_imgAvatar addGestureRecognizer:tapImgAvatar];
    [_imgAddFriend addGestureRecognizer:tapImgFriend];
    [_lblAddFriend addGestureRecognizer:tapLblFriend];
}

- (void)dataDidChange
{
    _friend = self.data;
    _lblUserName.text   = _friend.name.length > 0 ? _friend.name : LOCALIZATION(@"匿名");
    _lblAddFriend.text  = _friend.isFriend ? LOCALIZATION(@"取消关注") : LOCALIZATION(@"加书友");
    _imgAddFriend.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _friend.isFriend ? @"icon_friend_added" : @"icon_friend_add"]];
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_friend.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    
    NSArray *arrFriendIds = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_FriendIdsList];
    if ([arrFriendIds containsObject:@(_friend.userId)]) {
        [self isFriend];
    }
}

- (void)isFriend
{
    _lblAddFriend.text = _friend.isFriend ? LOCALIZATION(@"取消关注") : LOCALIZATION(@"加书友");
    _imgAddFriend.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _friend.isFriend ? @"icon_friend_added" : @"icon_friend_add"]];
    _lblAddFriend.textColor = _friend.isFriend ? [UIColor cm_blackColor_666666_1] : [UIColor cm_mainColor];
}

- (void)toFriendInfo
{
    if ([self.delegate respondsToSelector:@selector(toFriendInfoWithFriend:)]) {
        [self.delegate toFriendInfoWithFriend:self.data];
    }
}

- (void)addFriend
{
    _friend.isFriend = !_friend.isFriend;
    [self isFriend];
    if (_friend.isFriend)
        [self.delegate addFriendWithFriend:_friend];
    else
        [self.delegate delFriendWithFriend:_friend];
}

@end
