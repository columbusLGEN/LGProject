//
//  UMessageSystemTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UMessageSystemTableViewCell.h"

@interface UMessageSystemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgContent;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIView *viewUnRead;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@end

@implementation UMessageSystemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configMessageCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateSystemLanguage
{
    
}
- (void)configMessageCell
{
    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    
    _imgAvatar.layer.borderWidth = 3.f;
    _imgAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = 0.1;
    _viewShadow.layer.shadowRadius  = 1;
    _viewShadow.backgroundColor     = [UIColor clearColor];
    
    _lblName.textColor    = [UIColor cm_blackColor_333333_1];
    _lblContent.textColor = [UIColor cm_blackColor_666666_1];
    _lblTime.textColor    = [UIColor cm_blackColor_666666_1];
    
    _lblName.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblTime.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblContent.font = [UIFont systemFontOfSize:cFontSize_16 - 2];
    
    _viewUnRead.layer.masksToBounds = YES;
    _viewUnRead.layer.cornerRadius  = _viewUnRead.height/2;
    
    _viewBackground.backgroundColor = [UIColor cm_grayColor__F8F8F8_1];
    _viewBottom.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
}

#pragma mark - 获取数据

- (void)dataDidChange
{
    MessageModel *message = self.data;
    BOOL isCN = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese;
    if (isCN)
        _lblName.text = message.title.length > 0 ? message.title : LOCALIZATION(@"系统消息");
    else
        _lblName.text = message.en_title.length > 0 ? message.en_title : LOCALIZATION(@"系统消息");
    
    _lblTime.text    = message.emailCreatedTime;
    _lblContent.text = isCN ? message.message : message.en_message;
    
    _viewUnRead.hidden = message.type == ENUM_MessageReadTypeReaded;
    
    _imgAvatar.image = message.messageType == ENUM_MessageTypeActivity ? [UIImage imageNamed:@"img_avatar_activity"] : [UIImage imageNamed:@"img_avatar_system"];
    [_imgContent sd_setImageWithURL:[NSURL URLWithString:message.iconUrl] placeholderImage:nil];
}

/** 标记已读，隐藏小红点 */
- (void)updateReadType:(ENUM_MessageReadType)type
{
    _viewUnRead.hidden = YES;
}

@end
