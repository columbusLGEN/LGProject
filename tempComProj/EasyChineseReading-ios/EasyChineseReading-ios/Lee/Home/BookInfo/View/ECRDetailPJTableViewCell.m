//
//  ECRDetailPJTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRDetailPJTableViewCell.h"
#import "ECRScoreUserModel.h"
#import "ZStarView.h"
#import "NSString+TOPExtension.h"

@interface ECRDetailPJTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *iconBg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *pjTime;
@property (strong, nonatomic) ZStarView *star;

@end

@implementation ECRDetailPJTableViewCell

- (void)setModel:(ECRScoreUserModel *)model{
    _model = model;
//    NSString *userName;
//    NSUInteger ccCount = [model.name ChineseCharacterCount];
//    if ((model.name.length + ccCount) > 10) {
//        userName = [NSString stringWithFormat:@"%@...",[model.name substringToIndex:7]];
//    }else{
//        userName = model.name;
//    }
//    _userName.text = userName;
//    NSLog(@"ZStarView -- %@ -- %@ -- %f",model.name,userName,model.score);
    
    _userName.text = model.name;
    [_star setScore:model.score withAnimation:NO];
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPAvatarPlaceHolder];
    _pjTime.text = [model.createdTime substringToIndex:11];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _star = [[ZStarView alloc] initWithFrame:_starView.bounds numberOfStar:5];
    _star.canChange = NO;
    [_starView addSubview:_star];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _icon.clipsToBounds = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat los;
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        los = 27;
    }else{
        los = 20;
    }
    _icon.layer.cornerRadius = los;// _icon.width * 0.5
    _icon.layer.masksToBounds = YES;
    _iconBg.layer.cornerRadius = los;//_iconBg.width * 0.5;
    _iconBg.layer.masksToBounds = YES;
    _iconBg.layer.borderWidth = 1;
    _iconBg.layer.borderColor = [UIColor colorWithHexString:@"e3e3e3"].CGColor;
}

- (CGFloat)cellHeight{
    return 70;
}

@end
