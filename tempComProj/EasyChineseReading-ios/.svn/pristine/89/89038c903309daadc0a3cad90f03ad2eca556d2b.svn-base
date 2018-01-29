//
//  UFriendDynamicNewTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UFriendDynamicTableViewCell.h"

@interface UFriendDynamicTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewBookInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover;

@property (weak, nonatomic) IBOutlet UILabel *lblBookName;
@property (weak, nonatomic) IBOutlet UILabel *lblBookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIView *viewStar;

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurr;

@property (strong, nonatomic) ZStarView *star; // 评分
@property (strong, nonatomic) DynamicModel *dynamic;

@end

@implementation UFriendDynamicTableViewCell

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
    [self configBookView];
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
    _viewShadow.layer.shadowOpacity = .1f;
    _viewShadow.layer.shadowRadius  = 1.f;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _imgAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFriendInfoView)];
    [_imgAvatar addGestureRecognizer:tapAvatar];
}
// 配置分享人
- (void)configUserInfoView
{
    _lblName.textColor = [UIColor cm_blackColor_333333_1];
    _lblName.font      = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblTime.textColor = [UIColor cm_blackColor_333333_1];
    _lblTime.font      = [UIFont systemFontOfSize:cFontSize_12];
    
    _lblTitle.textColor = [UIColor cm_blackColor_333333_1];
    _lblTitle.font      = [UIFont systemFontOfSize:cFontSize_14];
    
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
}
// 配置图书
- (void)configBookView
{
    _lblBookName.textColor = [UIColor cm_blackColor_333333_1];
    _lblBookName.font      = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblBookAuthor.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblBookAuthor.textColor = [UIColor cm_blackColor_333333_1];
    
    _lblPrice.font      = [UIFont systemFontOfSize:cFontSize_16];
    _lblPrice.textColor = [UIColor cm_orangeColor_FF5910_1];
    
    _star = [[ZStarView alloc] initWithFrame:CGRectMake(0, 0, 15*5, 15) numberOfStar:5];
    _star.canChange = NO;
    [_viewStar addSubview:_star];
    
    _viewBookInfo.backgroundColor = [UIColor cm_grayColor__F8F8F8_1];
    _viewBookInfo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapBook = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toBookDetailView)];
    [_viewBookInfo addGestureRecognizer:tapBook];
    _imgVirtualCurr.image = [UIImage imageNamed:@"icon_virtual_currency"];
}

#pragma mark -

- (void)dataDidChange
{
    _dynamic = self.data;
    
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_dynamic.friendIconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    _lblName.text  = _dynamic.friendName.length > 0 ? _dynamic.friendName : LOCALIZATION(@"匿名");
    _lblTitle.text = _dynamic.shareTitle.length > 0 ? _dynamic.shareTitle : LOCALIZATION(@"这家伙很懒，什么也没有写");
    _lblTime.text  = _dynamic.createTime;
    
    _lblTitle.textColor = _dynamic.shareTitle.length > 0 ? [UIColor cm_blackColor_333333_1] : [UIColor cm_blackColor_666666_1];
    
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:_dynamic.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    _lblBookName.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _dynamic.bookName : _dynamic.en_bookName;
    _lblBookAuthor.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"),  [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _dynamic.author : _dynamic.en_author];
    
    _lblPrice.text = [NSString stringWithFormat:@"%.2f", _dynamic.price];
    
    [_star setScore:_dynamic.score withAnimation:YES];
}

#pragma mark -

- (void)toBookDetailView
{
    if ([self.delegate respondsToSelector:@selector(toBookDetailWithBookId:)]) {
        [self.delegate toBookDetailWithBookId:_dynamic.bookId];
    }
}

- (void)toFriendInfoView
{
    if ([self.delegate respondsToSelector:@selector(toFriendInfoWithFriend:)]) {
        FriendModel *friend = [FriendModel new];
        friend.userId = _dynamic.userId;
        friend.name = _dynamic.friendName.length > 0 ? _dynamic.friendName : LOCALIZATION(@"匿名");
        friend.iconUrl = _dynamic.friendIconUrl;
    
        [self.delegate toFriendInfoWithFriend:friend];
    }
}

@end
