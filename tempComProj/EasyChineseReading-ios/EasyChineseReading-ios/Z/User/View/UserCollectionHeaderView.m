//
//  UserCollectionHeaderView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserCollectionHeaderView.h"
#import <SDWebImage/SDWebImageManager.h>
@interface UserCollectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgCenter;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;
@property (weak, nonatomic) IBOutlet UIImageView *imgIntegral;
@property (weak, nonatomic) IBOutlet UIView *viewLeft;
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UIView *viewRight;

@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (weak, nonatomic) IBOutlet UILabel *lblLogin;       // 登录
@property (weak, nonatomic) IBOutlet UILabel *lblIntegral;    // 积分
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;       // 虚拟币

@property (weak, nonatomic) IBOutlet UILabel *lblDesReaded;   // 描述 读完
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadTime; // 描述 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblDesReadWords;// 描述 阅读字数

@property (weak, nonatomic) IBOutlet UILabel *lblReaded;       // 完成阅读
@property (weak, nonatomic) IBOutlet UILabel *lblReadTime;     // 总阅读小时
@property (weak, nonatomic) IBOutlet UILabel *lblReadWords;    // 阅读字数
@property (weak, nonatomic) IBOutlet UILabel *lblRanking;      // 阅读排名

@property (weak, nonatomic) IBOutlet UIButton *btnShowing;     // 晒一晒

@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewRigthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCenterWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCenterWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftIconLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerIconLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftIconRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerIconRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topRankingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botRankingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botBtnShareConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBotViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botBotViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBotIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botBotLblConstraint;

@end

@implementation UserCollectionHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configManager];
}

#pragma mark - 配置 个人中心 header 界面

- (void)configManager
{
    [self configHeaderView];
    [self configGestureRecognizer];
    [self updateHeaderConstraint];
    [self configHeaderFont:[UIFont systemFontOfSize:isPad ? cFontSize_16 : cFontSize_14]];
    [self updateSystemLanguage];
    [self fk_observeNotifcation:kNotificationLanguageChanged usingBlock:^(NSNotification *note) {
        [self updateSystemLanguage];
    }];
}

- (void)configHeaderView
{
    _imgBackground.image = [UIImage imageNamed:@"img_background_user"];
    _imgIntegral.image   = [UIImage imageNamed:@"icon_user_integral"];
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_user_virtual_currency"];

    _imgAvatar.layer.borderColor   = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth   = 3.f;
    _imgAvatar.layer.cornerRadius  = _imgAvatar.width/2;
    _imgAvatar.layer.masksToBounds = YES;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = 0.3;
    _viewShadow.layer.shadowRadius  = 1;
    _viewShadow.backgroundColor     = [UIColor clearColor];
    
    UIColor *titleColor;
    UIColor *backColor;
    switch ([LGSkinSwitchManager getCurrentUserSkin]) {
        case ECRHomeUITypeDefault:
            titleColor = [UIColor whiteColor];
            backColor  = [UIColor cm_blackColor_000000_5F];
            _imgLeft.image   = [UIImage imageNamed:@"icon_user_read_time"];
            _imgCenter.image = [UIImage imageNamed:@"icon_user_read_book"];
            _imgRight.image  = [UIImage imageNamed:@"icon_user_read_word"];
            _viewLine.backgroundColor = [UIColor cm_whiteColor_FFFFFF_7F];
            break;
        case ECRHomeUITypeAdultTwo:
            titleColor = [UIColor cm_blackColor_333333_1];
            backColor  = [UIColor cm_whiteColor_FFFFFF_7F];
            _imgLeft.image   = [UIImage imageNamed:@"icon_friend_read_time"];
            _imgCenter.image = [UIImage imageNamed:@"icon_friend_read_book"];
            _imgRight.image  = [UIImage imageNamed:@"icon_friend_read_word"];
            _viewLine.backgroundColor = [UIColor cm_blackColor_000000_2F];
            break;
        case ECRHomeUITypeKidOne:
            titleColor = [UIColor cm_blackColor_333333_1];
            backColor  = [UIColor cm_whiteColor_FFFFFF_7F];
            _imgLeft.image   = [UIImage imageNamed:@"icon_user_read_time"];
            _imgCenter.image = [UIImage imageNamed:@"icon_user_read_book"];
            _imgRight.image  = [UIImage imageNamed:@"icon_user_read_word"];
            _viewLine.backgroundColor = [UIColor cm_blackColor_000000_2F];
            break;
        case ECRHomeUITypeKidtwo:
            titleColor = [UIColor cm_blackColor_333333_1];
            backColor  = [UIColor cm_whiteColor_FFFFFF_7F];
            _imgLeft.image   = [UIImage imageNamed:@"icon_user_read_time"];
            _imgCenter.image = [UIImage imageNamed:@"icon_user_read_book"];
            _imgRight.image  = [UIImage imageNamed:@"icon_user_read_word"];
            break;
        default:
            break;
    }
    NSMutableAttributedString *ranking = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我战胜了 0%% 的书友"]];
    // 获取要调整颜色的文字位置,调整颜色
    NSRange rangePercent = [[ranking string] rangeOfString:@"0%"];
    NSRange upRange = NSMakeRange(rangePercent.location, rangePercent.length);
    [ranking addAttribute:NSForegroundColorAttributeName value:[UIColor cm_yellowColor_FFE402_1] range:upRange];
    _lblRanking.attributedText = ranking;
    
    _lblLogin.textColor = _lblMoney.textColor = _lblIntegral.textColor = _lblRanking.textColor = _lblDesReadTime.textColor = _lblDesReaded.textColor = _lblDesReadWords.textColor = _lblReaded.textColor = _lblReadTime.textColor = _lblReadWords.textColor = titleColor;
    _viewLeft.backgroundColor = _viewCenter.backgroundColor = _viewRight.backgroundColor = backColor;
}

- (void)updateHeaderConstraint
{
    _avatarTopConstraint.constant = [IPhoneVersion deviceVersion] == iphoneX ? cHeaderHeight_88 : cHeaderHeight_64;
    _leftViewLeftConstraint.constant     = isPad ? 15.f : 5.f;
    _rightViewRigthConstraint.constant   = isPad ? 15.f : 5.f;
    _leftCenterWidthConstraint.constant  = isPad ? 20.f : 5.f;
    _rightCenterWidthConstraint.constant = isPad ? 20.f : 5.f;
    
    _leftIconLeftConstraint.constant     = isPad ? 25.f : 10.f;
    _centerIconLeftConstraint.constant   = isPad ? 25.f : 10.f;
    _rightIconLeftConstraint.constant    = isPad ? 25.f : 10.f;
    
    _leftIconRightConstraint.constant    = isPad ? 15.f : 5.f;
    _centerIconRightConstraint.constant  = isPad ? 15.f : 5.f;
    _rightIconRightConstraint.constant   = isPad ? 15.f : 5.f;
    
    // 高度
    _topRankingConstraint.constant       = isPad ? 25.f : 5.f;
    _botRankingConstraint.constant       = isPad ? 35.f : 5.f;
    _botBtnShareConstraint.constant      = isPad ? 45.f : 20.f;
    _heightBotViewConstraint.constant    = isPad ? 95.f : 80.f;
    _botBotViewConstraint.constant       = isPad ? 35.f : 10.f;
    
    _topBotIconConstraint.constant       = isPad ? 15.f : 10.f;
    _botBotLblConstraint.constant        = isPad ? 15.f : 10.f;
}

- (void)configHeaderFont:(UIFont *)font
{
    _lblReaded.font    = font;
    _lblReadTime.font  = font;
    _lblReadWords.font = font;
    
    _lblDesReaded.font    = font;
    _lblDesReadTime.font  = font;
    _lblDesReadWords.font = font;
    
    _lblRanking.font  = font;
    _lblMoney.font    = font;
    _lblIntegral.font = font;
    
    _lblLogin.font = [UIFont systemFontOfSize:cFontSize_18];
}

#pragma mark - 添加手势

- (void)configGestureRecognizer
{
    UITapGestureRecognizer *tap_imgAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAvatar:)];
    [_imgAvatar addGestureRecognizer:tap_imgAvatar];
    
    UITapGestureRecognizer *tap_login = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLblLoginOrUserInfo:)];
    [_lblLogin addGestureRecognizer:tap_login];
    
    UITapGestureRecognizer *tap_integral = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLblIntegral:)];
    [_lblIntegral addGestureRecognizer:tap_integral];
    
    UITapGestureRecognizer *tap_virCurrency = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLblVirtualCurrency:)];
    [_lblMoney addGestureRecognizer:tap_virCurrency];
}

#pragma mark - 切换语言 更新界面

- (void)updateSystemLanguage
{
    _lblLogin.text          = LOCALIZATION(@"登录/注册");
    _lblIntegral.text       = [NSString stringWithFormat:@"%@: 0", LOCALIZATION(@"积分")];
    _lblMoney.text          = [NSString stringWithFormat:@"%@: 0", LOCALIZATION(@"虚拟币")];
    _lblRanking.text        = [NSString stringWithFormat:@"%@ 0%% %@", LOCALIZATION(@"我战胜了"), LOCALIZATION(@"的书友")];
    _lblDesReadTime.text    = LOCALIZATION(@"总阅读小时");
    _lblDesReaded.text      = LOCALIZATION(@"已完成阅读");
    _lblDesReadWords.text   = LOCALIZATION(@"总阅读字数");
    _lblReadTime.text       = [NSString stringWithFormat:@"0 %@", LOCALIZATION(@"小时")];
    _lblReaded.text         = [NSString stringWithFormat:@"0 %@", LOCALIZATION(@"本")];
    _lblReadWords.text      = [NSString stringWithFormat:@"0 %@", LOCALIZATION(@"字")];
    
    [_btnShowing setImage:[UserRequest sharedInstance].language == ENUM_LanguageTypeEnglish ? [UIImage imageNamed:@"img_share_user_info_english"] : [UIImage imageNamed:@"img_share_user_info"] forState:UIControlStateNormal];
}

#pragma mark - 获取数据

- (void)dataDidChange
{
    UserModel *user = self.data;
    
    // 判断是否登录
    if (user.userId)
        _lblLogin.text = user.name.length > 0 ? user.name : LOCALIZATION(@"匿名");
    else
        _lblLogin.text = LOCALIZATION(@"登录/注册");
    
    UIImage *imgAvatar = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_UserAvatar];
    NSString *strAvatar = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_avatarUrl];
    
    // 判断用户是否有头像
    if (imgAvatar && user.userId && [user.iconUrl is:strAvatar])
        _imgAvatar.image = imgAvatar;
    else
        _imgAvatar.image = [UIImage imageNamed:@"img_avatar_placeholder"];
        
    if ([strAvatar empty] || strAvatar == nil || [user.iconUrl isNot:strAvatar]) {
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.iconUrl]
                      placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                 if (image) {
                                     [[CacheDataSource sharedInstance] setCache:user.iconUrl withCacheKey:CacheKey_avatarUrl];
                                     [[CacheDataSource sharedInstance] setCache:image withCacheKey:CacheKey_UserAvatar];
                                 }
                                 [[SDImageCache sharedImageCache] clearMemory];
                             }];
    }
    
    _lblIntegral.text = [NSString stringWithFormat:@"%@: %ld", LOCALIZATION(@"积分"), user ? user.score : 0];
    _lblMoney.text = [NSString stringWithFormat:@"%@: %.2f", LOCALIZATION(@"虚拟币"), user ? user.virtualCurrency : 0];
    UIColor *titleColor = [UIColor cm_yellowColor_FFE402_1];
    switch ([LGSkinSwitchManager getCurrentUserSkin]) {
        case ECRHomeUITypeDefault:
            titleColor = [UIColor cm_yellowColor_FFE402_1];
            break;
        case ECRHomeUITypeAdultTwo:
            titleColor = [UIColor cm_mainColor];
            break;
        case ECRHomeUITypeKidOne:
            titleColor = [UIColor cm_orangeColor_FF8400_1];
            break;
        case ECRHomeUITypeKidtwo:
            
            break;
        default:
            break;
    }
    
    // 超越书友
    NSMutableAttributedString *ranking = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld%% %@",LOCALIZATION(@"我战胜了"), user ? user.ranking : 0, LOCALIZATION(@"的书友")]];
    // 获取要调整颜色的文字位置,调整颜色
    NSRange rangeRanking = [[ranking string] rangeOfString:[NSString stringWithFormat:@"%ld", user.ranking]];
    NSRange rangePercentRanking = [[ranking string] rangeOfString:@"%"];
    // 更新第一个数字到%之间的范围
    NSRange upRange = NSMakeRange(rangePercentRanking.location - rangeRanking.length, rangeRanking.length + 1);
    [ranking addAttribute:NSForegroundColorAttributeName value:titleColor range:upRange];
    NSRange upRangeFont = NSMakeRange(upRange.location, upRange.length - 1);
    [ranking addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:isPad ? 30.f : 24.f] range:upRangeFont];
    _lblRanking.attributedText = ranking;
    
    // 已完成阅读
    NSMutableAttributedString *readed   = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld %@", user ? user.readThrough : 0, LOCALIZATION(@"本")]];
    NSRange upRangeReaded = NSMakeRange(0, [NSString stringWithFormat:@"%ld", user ? user.readThrough : 0].length);
    [readed addAttribute:NSForegroundColorAttributeName value:titleColor range:upRangeReaded];
    [readed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:isPad ? 24.f : cFontSize_18] range:upRangeReaded];
    _lblReaded.attributedText = readed;
    
    // 总阅读小时
    NSMutableAttributedString *readTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld %@", user ? user.readTime : 0, LOCALIZATION(@"小时")]];
    NSRange upRangeReadTime = NSMakeRange(0, [NSString stringWithFormat:@"%ld", user ? user.readTime : 0].length);
    [readTime addAttribute:NSForegroundColorAttributeName value:titleColor range:upRangeReadTime];
    [readTime addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:isPad ? 24.f : cFontSize_18] range:upRangeReadTime];
    _lblReadTime.attributedText = readTime;
    
    // 总阅读字数
    NSMutableAttributedString *readWord = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld %@", user ? user.wordCount : 0, LOCALIZATION(@"字")]];
    NSRange upRangeReadWord = NSMakeRange(0, [NSString stringWithFormat:@"%ld", user ? user.wordCount : 0].length);
    [readWord addAttribute:NSForegroundColorAttributeName value:titleColor range:upRangeReadWord];
    [readWord addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:isPad ? 24.f : cFontSize_18] range:upRangeReadWord];
    _lblReadWords.attributedText = readWord;
}

#pragma mark - 用户交互

/** 点击头像 */
- (void)tapImageAvatar:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapAvatar)]) {
        [self.delegate tapAvatar];
    }
}

/** 登录或者查看个人信息 */
- (void)tapLblLoginOrUserInfo:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapLoginOrUserInfo)]) {
        [self.delegate tapLoginOrUserInfo];
    }
}

/** 查看积分 */
- (void)tapLblIntegral:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapIntegral)]) {
        [self.delegate tapIntegral];
    }
}

/** 查看虚拟币 */
- (void)tapLblVirtualCurrency:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(tapVirtualCurrency)]) {
        [self.delegate tapVirtualCurrency];
    }
}

/** 晒一晒 */
- (IBAction)click_btnShowing:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareMyReadingInfomation)]) {
        [self.delegate shareMyReadingInfomation];
    }
}

@end
