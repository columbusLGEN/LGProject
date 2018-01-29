//
//  UFriendInfoHeaderView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UFriendInfoHeaderView.h"

@interface UFriendInfoHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;      // 头像
@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@property (weak, nonatomic) IBOutlet UIView *viewVerLine;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (weak, nonatomic) IBOutlet UILabel *lblName;            // 用户名

@property (weak, nonatomic) IBOutlet UILabel *lblDesReaded;   // 描述 读完
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadTime; // 描述 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadWords;// 描述 阅读字数
@property (weak, nonatomic) IBOutlet UILabel *lblDesBooks;

@property (weak, nonatomic) IBOutlet UILabel *lblReaded;       // 读完
@property (weak, nonatomic) IBOutlet UILabel *lblReadTime;     // 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblReadWords;    // 阅读字数
@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgCenter;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;

@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewRigthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftIconLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerIconLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftIconRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerIconRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconRightConstraint;

@end

@implementation UFriendInfoHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configManager];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawRoundedRectPathWithView:_viewBackground];
}

#pragma mark - 配置界面

- (void)configManager
{
    [self configHeaderView];
    [self configHeaderViewMainColor:[UIColor cm_mainColor]];
    [self updateHeaderConstraint];
    [self bringSubviewToFront:_viewShadow];
}

- (void)configHeaderViewMainColor:(UIColor *)mainColor
{
    _lblReaded.textColor = mainColor;
    _lblReadTime.textColor = mainColor;
    _lblReadWords.textColor = mainColor;
    
    _viewVerLine.backgroundColor = mainColor;
}

- (void)configHeaderView
{
    self.backgroundColor = [UIColor whiteColor];
    _viewBackground.backgroundColor = [UIColor clearColor];
    
    _imgLeft.image   = [UIImage imageNamed:@"icon_friend_read_time"];
    _imgCenter.image = [UIImage imageNamed:@"icon_friend_read_book"];
    _imgRight.image  = [UIImage imageNamed:@"icon_friend_read_word"];
    
    _lblDesReaded.text    = LOCALIZATION(@"已完成阅读");
    _lblDesReadTime.text  = LOCALIZATION(@"总阅读小时");
    _lblDesReadWords.text = LOCALIZATION(@"总阅读字数");
    _lblDesBooks.text     = LOCALIZATION(@"Ta正在读");
    
    _leftLine.backgroundColor  = [UIColor cm_lineColor_D9D7D7_1];
    _rightLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth = 3.f;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = 0.5;
    _viewShadow.layer.shadowRadius  = 1;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _lblName.textColor         = [UIColor cm_blackColor_333333_1];
    _lblDesReaded.textColor    = [UIColor cm_blackColor_333333_1];
    _lblDesReadTime.textColor  = [UIColor cm_blackColor_333333_1];
    _lblDesReadWords.textColor = [UIColor cm_blackColor_333333_1];
    
    UIFont *fitSizeFont = [UIFont systemFontOfSize:isPad ? cFontSize_16 : cFontSize_14];

    _lblDesReaded.font    = fitSizeFont;
    _lblDesReadTime.font  = fitSizeFont;
    _lblDesReadWords.font = fitSizeFont;
    _lblReaded.font    = fitSizeFont;
    _lblReadTime.font  = fitSizeFont;
    _lblReadWords.font = fitSizeFont;
}

- (void)updateHeaderConstraint
{
    _backViewLeftConstraint.constant    = isPad ? 10.f : 5.f;
    _backViewRigthConstraint.constant   = isPad ? 10.f : 5.f;
    
    _leftIconLeftConstraint.constant    = isPad ? 25.f : 10.f;
    _centerIconLeftConstraint.constant  = isPad ? 25.f : 10.f;
    _rightIconLeftConstraint.constant   = isPad ? 25.f : 10.f;
    
    _leftIconRightConstraint.constant   = isPad ? 15.f : 5.f;
    _centerIconRightConstraint.constant = isPad ? 15.f : 5.f;
    _rightIconRightConstraint.constant  = isPad ? 15.f : 5.f;
}

#pragma mark - 数据

- (void)dataDidChange
{
    FriendModel *user = self.data;
    ReadHistoryModel *readHistory = [ReadHistoryModel mj_objectWithKeyValues:user.readHistory.firstObject];
    NSLog(@"canview %d", user.canview);
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    
    _lblName.text = [user.name notEmpty] ? user.name : LOCALIZATION(@"匿名");
    if (user.canview) {
        _lblReaded.text    = [NSString stringWithFormat:@"%ld %@", readHistory.readThrough, LOCALIZATION(@"本")];
        _lblReadTime.text  = [NSString stringWithFormat:@"%ld %@", readHistory.readTime, LOCALIZATION(@"小时")];
        _lblReadWords.text = [NSString stringWithFormat:@"%ld %@", readHistory.wordCount, LOCALIZATION(@"字")];
    }
    else {
        _lblReaded.text    = [NSString stringWithFormat:@"** %@", LOCALIZATION(@"本")];
        _lblReadTime.text  = [NSString stringWithFormat:@"** %@", LOCALIZATION(@"小时")];
        _lblReadWords.text = [NSString stringWithFormat:@"** %@", LOCALIZATION(@"字")];
    }
}

@end
