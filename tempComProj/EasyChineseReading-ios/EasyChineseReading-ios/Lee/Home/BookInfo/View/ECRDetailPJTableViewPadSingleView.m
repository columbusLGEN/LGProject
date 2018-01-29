//
//  ECRDetailPJTableViewPadSingleView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/30.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRDetailPJTableViewPadSingleView.h"
#import "ECRScoreUserModel.h"

@interface ECRDetailPJTableViewPadSingleView ()
@property (weak, nonatomic) IBOutlet UIView *iconBg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet ZStarView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation ECRDetailPJTableViewPadSingleView

- (void)setModel:(ECRScoreUserModel *)model{
    _model = model;
    _userName.text = model.name;
    [_starView setScore:model.score withAnimation:YES];
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPlaceHolderImg];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _icon.clipsToBounds = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat los;
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        los = 30;
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

+ (instancetype)pjSingleView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ECRDetailPJTableViewPadSingleView" owner:nil options:nil] firstObject];
}

@end
