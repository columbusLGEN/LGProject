//
//  UFriendReadNewTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UFriendReadTableViewCell.h"

@interface UFriendReadTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;  // 头像

@property (weak, nonatomic) IBOutlet UIView *viewBackground;  // 背景

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;    // 用户名
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;        // 分享说明
@property (weak, nonatomic) IBOutlet UILabel *lblTime;        // 分享时间

@property (weak, nonatomic) IBOutlet UILabel *lblDesReaded;   // 描述 读完
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadTime; // 描述 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadWords;// 描述 阅读字数

@property (weak, nonatomic) IBOutlet UILabel *lblReaded;      // 读完
@property (weak, nonatomic) IBOutlet UILabel *lblReadTime;    // 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblReadWords;   // 阅读字数
@property (weak, nonatomic) IBOutlet UIImageView *imgReadTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgReadBook;
@property (weak, nonatomic) IBOutlet UIImageView *imgReadWord;

@property (weak, nonatomic) IBOutlet UIView *viewTLine;
@property (weak, nonatomic) IBOutlet UIView *viewBLine;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (strong, nonatomic) DynamicModel *dynamic;

@end

@implementation UFriendReadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configManager];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawRoundedRectPathWithView:_viewBackground];
}

#pragma mark -

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
    
    _viewTLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewBLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewLine.backgroundColor  = [UIColor cm_lineColor_D9D7D7_1];
    UITapGestureRecognizer *tapUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFriendInfoView)];
    _imgAvatar.userInteractionEnabled = YES;
    [_imgAvatar addGestureRecognizer:tapUser];
    
    _imgReadTime.image = [UIImage imageNamed:@"icon_friend_read_time"];
    _imgReadBook.image = [UIImage imageNamed:@"icon_friend_read_book"];
    _imgReadWord.image = [UIImage imageNamed:@"icon_friend_read_word"];
    
    [self configViewColor:[UIColor cm_mainColor]];
    [self configViewFont];
}

- (void)configViewColor:(UIColor *)mainColor
{
    _lblUserName.textColor     = [UIColor cm_blackColor_333333_1];
    _lblTime.textColor         = [UIColor cm_blackColor_333333_1];
    _lblDesc.textColor         = [UIColor cm_blackColor_333333_1];
    
    _lblDesReaded.textColor    = mainColor;
    _lblDesReadTime.textColor  = mainColor;
    _lblDesReadWords.textColor = mainColor;
    _lblReaded.textColor       = [UIColor cm_blackColor_666666_1];
    _lblReadTime.textColor     = [UIColor cm_blackColor_666666_1];
    _lblReadWords.textColor    = [UIColor cm_blackColor_666666_1];
}

- (void)configViewFont
{
    UIFont *kFont_16 = [UIFont systemFontOfSize:cFontSize_16];
    UIFont *kFont_14 = [UIFont systemFontOfSize:cFontSize_14];
    UIFont *kFont_12 = [UIFont systemFontOfSize:cFontSize_12];
    
    _lblUserName.font = kFont_16;
    _lblDesc.font     = kFont_12;
    _lblTime.font     = kFont_12;
    
    _lblReaded.font    = kFont_14;
    _lblReadTime.font  = kFont_14;
    _lblReadWords.font = kFont_14;
    
    _lblDesReaded.font    = kFont_14;
    _lblDesReadTime.font  = kFont_14;
    _lblDesReadWords.font = kFont_14;
}

#pragma mark - 

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
    
    
    NSMutableAttributedString *readThrough = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld %@", _dynamic.readThrough, LOCALIZATION(@"本")]];
    NSMutableAttributedString *readTime    = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld %@", _dynamic.readTime,    LOCALIZATION(@"小时")]];
    NSMutableAttributedString *wordCount   = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld %@", _dynamic.wordCount,   LOCALIZATION(@"字")]];

    // 获取要调整颜色的文字位置,调整颜色
    NSRange upRangeReadThrough = NSMakeRange(0, [NSString stringWithFormat:@"%ld", _dynamic.readThrough].length);
    [readThrough addAttribute:NSForegroundColorAttributeName value:[UIColor cm_mainColor] range:upRangeReadThrough];
    [readThrough addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:24] range:upRangeReadThrough];
    _lblReaded.attributedText = readThrough;
    
    NSRange upRangeReadTime = NSMakeRange(0, [NSString stringWithFormat:@"%ld", _dynamic.readTime].length);
    [readTime addAttribute:NSForegroundColorAttributeName value:[UIColor cm_mainColor] range:upRangeReadTime];
    [readTime addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:24] range:upRangeReadTime];
    _lblReadTime.attributedText = readTime;
    
    NSRange upRangeWordCount = NSMakeRange(0, [NSString stringWithFormat:@"%ld", _dynamic.wordCount].length);
    [wordCount addAttribute:NSForegroundColorAttributeName value:[UIColor cm_mainColor] range:upRangeWordCount];
    [wordCount addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:24] range:upRangeWordCount];
    _lblReadWords.attributedText = wordCount;
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
