//
//  ECRHomeRMCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRHomeRMCell.h"
#import "ECRRankUser.h"

@interface ECRHomeRMCell ()
@property (weak, nonatomic) IBOutlet UIImageView *rankIcon;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *alreadyRead;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *iconBg;

@end

@implementation ECRHomeRMCell

//- (void)textDependsLauguage{
//    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
//
//    }else{
//
//    }
//}
- (void)textDependsLauguage{
    NSString *solidString = [LGPChangeLanguage localizedStringForKey:@"已经阅读"];
    NSString *ben = [LGPChangeLanguage localizedStringForKey:@"本书"];
    _alreadyRead.text = [NSString stringWithFormat:@"%@% ld %@",solidString,_model.readHave,ben];
}

- (void)setModel:(ECRRankUser *)model{
    _model = model;
    NSString *iiName = [NSString stringWithFormat:@"icon_bys_yddr_num_%ld",(model.indexInArray + 1)];// icon_bys_yddr_num_1
//    if (model.rank < 5) {
//    }else{
//        iiName = @"bys_yddr";
//    }
    [_rankIcon setImage:[UIImage imageNamed:iiName]];
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPAvatarPlaceHolder];
//    NSLog(@"place -- %@",LGPAvatarPlaceHolder);
    _name.text = model.name;
    [self textDependsLauguage];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _icon.layer.cornerRadius = _icon.width * 0.5;
    _icon.layer.masksToBounds = YES;
    _iconBg.layer.cornerRadius = _iconBg.width * 0.5;
    _iconBg.layer.masksToBounds = YES;
    _iconBg.layer.borderWidth = 1;
    _iconBg.layer.borderColor = [UIColor colorWithHexString:@"e3e3e3"].CGColor;
    self.line.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    _alreadyRead.textColor = [UIColor cm_blackColor_333333_1];
}
- (CGFloat)cellHeight{
    return 60;
}

@end
