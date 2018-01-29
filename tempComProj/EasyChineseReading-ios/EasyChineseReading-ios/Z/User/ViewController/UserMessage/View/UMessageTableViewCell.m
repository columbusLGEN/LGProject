//
//  UMessageTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UMessageTableViewCell.h"

@interface UMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIView *viewUnRead;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@end

@implementation UMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configMessageCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - 配置界面

- (void)configMessageCell {
    _imgAvatar.layer.cornerRadius = _imgAvatar.height/2;
    _imgAvatar.layer.borderWidth  = 3.f;
    _imgAvatar.layer.borderColor  = [UIColor whiteColor].CGColor;
    
    _viewShadow.layer.shadowOffset  = CGSizeMake(0, 0);
    _viewShadow.layer.shadowOpacity = 0.1;
    _viewShadow.layer.shadowRadius  = 1;
    _viewShadow.backgroundColor     = [UIColor clearColor];
    
    _viewUnRead.layer.masksToBounds = YES;
    _viewUnRead.layer.cornerRadius  = _viewUnRead.height/2;
    
    _lblName.textColor    = [UIColor cm_blackColor_333333_1];
    _lblTime.textColor    = [UIColor cm_blackColor_666666_1];
    _lblContent.textColor = [UIColor cm_blackColor_666666_1];
    
    _lblName.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblTime.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblContent.font = [UIFont systemFontOfSize:cFontSize_16 - 2];
    
    _viewBackground.backgroundColor = [UIColor cm_grayColor__F8F8F8_1];
    _viewBottom.backgroundColor     = [UIColor cm_grayColor__F1F1F1_1];
}

#pragma mark - 获取数据

- (void)dataDidChange {
    BOOL isCN = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese;

    MessageModel *message = self.data;
    _lblName.text = message.source == 0 ? LOCALIZATION(@"系统消息") : message.name;
    _lblTime.text = message.emailCreatedTime;

    if (message.source == 0)
        _lblContent.text = isCN ? (message.message.length > 0 ? message.message : message.en_message) : (message.en_message.length > 0 ? message.en_message : message.message);
    else
        _lblContent.text = message.message;

    _viewUnRead.hidden = message.type == ENUM_MessageReadTypeReaded;
    // 根据消息来源，判断头像
    if (message.source == 0)
        _imgAvatar.image = message.messageType == ENUM_MessageTypeSystem ? [UIImage imageNamed:@"img_avatar_system"] : [UIImage imageNamed:@"img_avatar_activity"];
    else
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:message.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
}

/** 标记已读，隐藏小红点 */
- (void)updateReadType:(ENUM_MessageReadType)type {
    _viewUnRead.hidden = YES;
}

@end
