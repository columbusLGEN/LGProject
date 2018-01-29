//
//  UFriendReadPadTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/7.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UFriendReadPadTableViewCell.h"

@interface UFriendReadPadTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;  // 头像
@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@property (weak, nonatomic) IBOutlet UIView *viewBackground;  // 背景

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;    // 用户名
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;        // 分享说明
@property (weak, nonatomic) IBOutlet UILabel *lblTime;        // 分享时间

@property (weak, nonatomic) IBOutlet UILabel *lblDesReaded;   // 描述 读完
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadTime; // 描述 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadWords;// 描述 阅读字数

@property (weak, nonatomic) IBOutlet UILabel *lblReaded;       // 读完
@property (weak, nonatomic) IBOutlet UILabel *lblReadTime;     // 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblReadWords;    // 阅读字数

@property (weak, nonatomic) IBOutlet UIView *viewLLine;
@property (weak, nonatomic) IBOutlet UIView *viewRLine;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (strong, nonatomic) DynamicModel *dynamic;

@end

@implementation UFriendReadPadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configManager];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawRoundedRectPathWithView:_viewBackground];
}

- (void)updateSystemLanguage
{
    _lblDesReaded.text    = LOCALIZATION(@"已完成阅读");
    _lblDesReadTime.text  = LOCALIZATION(@"总阅读小时");
    _lblDesReadWords.text = LOCALIZATION(@"总阅读字数");
}

- (void)configManager
{
    _viewBackground.backgroundColor = [UIColor clearColor];

    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    
    _imgAvatar.layer.borderWidth = 3.f;
    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = 0.1;
    _viewShadow.layer.shadowRadius  = 1;
    _viewShadow.backgroundColor = [UIColor clearColor];
    
    _viewLLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewRLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewLine.backgroundColor  = [UIColor cm_lineColor_D9D7D7_1];
    _viewBottom.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    
    UITapGestureRecognizer *tapUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFriendInfoView)];
    _imgAvatar.userInteractionEnabled = YES;
    [_imgAvatar addGestureRecognizer:tapUser];
    
    [self configViewColor:[UIColor cm_mainColor]];
    [self configViewFont];
}

- (void)configViewColor:(UIColor *)mainColor
{
    _lblReaded.textColor    = mainColor;
    _lblReadTime.textColor  = mainColor;
    _lblReadWords.textColor = mainColor;
    
    _lblUserName.textColor     = [UIColor cm_blackColor_333333_1];
    _lblTime.textColor         = [UIColor cm_blackColor_333333_1];
    _lblDesc.textColor         = [UIColor cm_blackColor_333333_1];
    _lblDesReaded.textColor    = [UIColor cm_blackColor_333333_1];
    _lblDesReadTime.textColor  = [UIColor cm_blackColor_333333_1];
    _lblDesReadWords.textColor = [UIColor cm_blackColor_333333_1];
}

- (void)configViewFont
{
    UIFont *defaultFont = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblUserName.font = defaultFont;
    _lblDesc.font     = defaultFont;
    _lblTime.font     = defaultFont;
    
    _lblReaded.font    = defaultFont;
    _lblReadTime.font  = defaultFont;
    _lblReadWords.font = defaultFont;
    
    _lblDesReaded.font    = defaultFont;
    _lblDesReadTime.font  = defaultFont;
    _lblDesReadWords.font = defaultFont;
}

- (void)dataDidChange
{
    _dynamic = self.data;
    
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_dynamic.friendIconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    _lblUserName.text = _dynamic.friendName.length > 0 ? _dynamic.friendName : LOCALIZATION(@"匿名");
    _lblTime.text = _dynamic.createTime;
    
    NSMutableAttributedString *ranking = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld%%%@", LOCALIZATION(@"我战胜了"), _dynamic.ranking, LOCALIZATION(@"的书友")]];
    // 获取要调整颜色的文字位置,调整颜色
    NSRange rangePercent = [[ranking string] rangeOfString:@"%"];
    // 更新第一个空格到%之间的范围
    NSRange upRange = NSMakeRange(rangePercent.location - [NSString stringWithFormat:@"%ld", _dynamic.ranking].length, [NSString stringWithFormat:@"%ld", _dynamic.ranking].length);
    [ranking addAttribute:NSForegroundColorAttributeName value:[UIColor cm_mainColor] range:upRange];
    _lblDesc.attributedText = ranking;
    
    _lblReaded.text    = [NSString stringWithFormat:@"%ld %@", _dynamic.readThrough, LOCALIZATION(@"本")];
    _lblReadTime.text  = [NSString stringWithFormat:@"%ld %@", _dynamic.readTime,    LOCALIZATION(@"小时")];
    _lblReadWords.text = [NSString stringWithFormat:@"%ld %@", _dynamic.wordCount,   LOCALIZATION(@"字")];
}

- (void)toFriendInfoView
{
    FriendModel *friend = [FriendModel new];
    friend.userId       = _dynamic.userId;
    friend.name         = _dynamic.friendName;
    friend.iconUrl      = _dynamic.friendIconUrl;
    [self.delegate toFriendInfoWithFriend:friend];
}

@end
