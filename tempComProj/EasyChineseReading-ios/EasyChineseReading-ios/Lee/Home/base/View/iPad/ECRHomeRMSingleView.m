//
//  ECRHomeRMSingleView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/30.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRHomeRMSingleView.h"
#import "ECRRankUser.h"

@interface ECRHomeRMSingleView ()
@property (weak, nonatomic) IBOutlet UIImageView *rankIcon;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *alreadyRead;
@property (weak, nonatomic) IBOutlet UIView *iconBg;

@end

@implementation ECRHomeRMSingleView

- (IBAction)ruClick:(UIButton *)sender {
    /// rank user click
    NSDictionary *userInfo = @{@"model":self.model};
    [[NSNotificationCenter defaultCenter] postNotificationName:LGPRankUserClickNotification object:nil userInfo:userInfo];
}

- (void)textDependsLauguage{
    NSString *solidString = [LGPChangeLanguage localizedStringForKey:@"已经阅读"];
    NSString *ben = [LGPChangeLanguage localizedStringForKey:@"本书"];
    _alreadyRead.text = [NSString stringWithFormat:@"%@% ld %@",solidString,_model.readHave,ben];
}

- (void)setModel:(ECRRankUser *)model{
    _model = model;
//    NSLog(@"model.indexinarray -- %ld",model.indexInArray);
    NSString *iiName = [NSString stringWithFormat:@"icon_bys_yddr_num_%ld",(model.indexInArray + 1)];
//    if (model.rank < 5) {
//    }else{
//        iiName = @"bys_yddr";
//    }
    [_rankIcon setImage:[UIImage imageNamed:iiName]];
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPAvatarPlaceHolder];
    _name.text = model.name;
    [self textDependsLauguage];
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    [super awakeFromNib];
    [self setNeedsLayout];
    [self layoutIfNeeded];

    _icon.layer.cornerRadius = _icon.width * 0.5;
    _icon.layer.masksToBounds = YES;
    _iconBg.layer.cornerRadius = _iconBg.width * 0.5;
    _iconBg.layer.masksToBounds = YES;
    _iconBg.layer.borderWidth = 1;
    _iconBg.layer.borderColor = [UIColor colorWithHexString:@"e3e3e3"].CGColor;
    _alreadyRead.textColor = [UIColor cm_blackColor_333333_1];
}

+ (instancetype)rmSingleView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ECRHomeRMSingleView" owner:nil options:nil] firstObject];
}

@end
