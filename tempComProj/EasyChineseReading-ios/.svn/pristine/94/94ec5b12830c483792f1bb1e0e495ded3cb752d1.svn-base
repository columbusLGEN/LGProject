//
//  UCRDetailStudentHeaderView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRDetailStudentHeaderView.h"

@interface UCRDetailStudentHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;      // 头像

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIView *viewProgressBack;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;

@property (weak, nonatomic) IBOutlet UILabel *lblDesReaded;   // 描述 读完
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadTime; // 描述 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadWords;// 描述 阅读字数

@property (weak, nonatomic) IBOutlet UILabel *lblReaded;       // 读完
@property (weak, nonatomic) IBOutlet UILabel *lblReadTime;     // 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblReadWords;    // 阅读字数

@property (weak, nonatomic) IBOutlet UIView *viewRLine;
@property (weak, nonatomic) IBOutlet UIView *viewLLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgCenter;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewRigthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftIconLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerIconLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftIconRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerIconRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconRightConstraint;

@end

@implementation UCRDetailStudentHeaderView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configView];
    [self updateHeaderConstraint];
}
    
- (void)updateSystemLanguage
{
    _lblDesReaded.text    = LOCALIZATION(@"已完成阅读");
    _lblDesReadTime.text  = LOCALIZATION(@"总阅读小时");
    _lblDesReadWords.text = LOCALIZATION(@"总阅读字数");
}

- (void)updateHeaderConstraint
{
    _backViewLeftConstraint.constant     = isPad ? 10.f : 4.f;
    _backViewRigthConstraint.constant    = isPad ? 10.f : 4.f;
    
    _leftIconLeftConstraint.constant     = isPad ? 25.f : 8.f;
    _centerIconLeftConstraint.constant   = isPad ? 25.f : 8.f;
    _rightIconLeftConstraint.constant    = isPad ? 25.f : 8.f;
    
    _leftIconRightConstraint.constant    = isPad ? 15.f : 4.f;
    _centerIconRightConstraint.constant  = isPad ? 15.f : 4.f;
    _rightIconRightConstraint.constant   = isPad ? 15.f : 4.f;
}

- (void)configView
{
    _imgLeft.image   = [UIImage imageNamed:@"icon_friend_read_time"];
    _imgCenter.image = [UIImage imageNamed:@"icon_friend_read_book"];
    _imgRight.image  = [UIImage imageNamed:@"icon_friend_read_word"];
    
    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    _imgAvatar.layer.borderColor  = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth  = 3.f;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = 0.5;
    _viewShadow.layer.shadowRadius  = 1;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _viewLLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewRLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblName.textColor         = _lblPercent.textColor = [UIColor cm_blackColor_333333_1];
    _lblDesReaded.textColor    = [UIColor cm_blackColor_333333_1];
    _lblDesReadTime.textColor  = [UIColor cm_blackColor_333333_1];
    _lblDesReadWords.textColor = [UIColor cm_blackColor_333333_1];
    
    _lblReaded.textColor    = [UIColor cm_orangeColor_FF5910_1];
    _lblReadTime.textColor  = [UIColor cm_orangeColor_FF5910_1];
    _lblReadWords.textColor = [UIColor cm_orangeColor_FF5910_1];
    
    _lblName.font =_lblPercent.font = [UIFont systemFontOfSize:cFontSize_16];
    
    UIFont *fitSizeFont = [UIFont systemFontOfSize:isPad ? cFontSize_16 : cFontSize_14];
    
    _lblReaded.font       = fitSizeFont;
    _lblReadTime.font     = fitSizeFont;
    _lblReadWords.font    = fitSizeFont;
    _lblDesReaded.font    = fitSizeFont;
    _lblDesReadTime.font  = fitSizeFont;
    _lblDesReadWords.font = fitSizeFont;
    
    _viewProgressBack.layer.masksToBounds = YES;
    _viewProgressBack.layer.cornerRadius  = _viewProgressBack.height/2;
    _viewProgressBack.layer.borderColor   = [UIColor cm_orangeColor_FF5910_1].CGColor;
    _viewProgressBack.layer.borderWidth   = .5f;
}

- (void)dataDidChange
{
    FriendModel *user = self.data;
    ReadHistoryModel *readHistory = [ReadHistoryModel mj_objectArrayWithKeyValuesArray:user.readHistory].firstObject;
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    
    _lblName.text      = [user.name notEmpty] ? user.name : LOCALIZATION(@"匿名");
    _lblPercent.text   = [NSString stringWithFormat:@"%.2f%%", user.readProgress];
    _lblReaded.text    = [NSString stringWithFormat:@"%ld %@", readHistory.readThrough, LOCALIZATION(@"本")];
    _lblReadTime.text  = [NSString stringWithFormat:@"%ld %@", readHistory.readTime, LOCALIZATION(@"小时")];
    _lblReadWords.text = [NSString stringWithFormat:@"%ld %@", readHistory.wordCount, LOCALIZATION(@"字")];
    
    UIView *frontView = [UIView new];
    CGFloat width = _viewProgressBack.width * user.readProgress / 100;
    frontView.frame = CGRectMake(0, 0, width, _viewProgressBack.height);
    frontView.backgroundColor = [UIColor cm_orangeColor_FF5910_1];
    [_viewProgressBack addSubview:frontView];
}

@end
