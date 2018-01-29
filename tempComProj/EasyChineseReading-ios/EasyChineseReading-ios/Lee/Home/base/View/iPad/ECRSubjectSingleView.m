//
//  ECRSubjectSingleView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/23.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRSubjectSingleView.h"
#import "ECRSubjectModel.h"

@interface ECRSubjectSingleView ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet ZStarView *score;
@property (weak, nonatomic) IBOutlet UILabel *priceNum;
@property (weak, nonatomic) IBOutlet UIImageView *icon_coin;


@end

@implementation ECRSubjectSingleView

- (IBAction)bookClick:(UIButton *)sender {
    NSDictionary *userInfo = @{@"model":self.model};
    [[NSNotificationCenter defaultCenter] postNotificationName:ECRSubjectBookClickNotification object:nil userInfo:userInfo];
}

- (void)setModel:(ECRSubjectModel *)model{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPAvatarPlaceHolder];
    _bookName.text = model.bookName;
    _author.text = model.author;
    _info.text = [NSString stringWithFormat:@"%@\n",model.contentValidity];
    _priceNum.text = [NSString stringWithFormat:@"%.2f",model.price];
    [_score setScore:model.score withAnimation:YES];
    
}

+ (instancetype)subjectSingleView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ECRSubjectSingleView" owner:nil options:nil]firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _icon_coin.image = [UIImage imageNamed:@"icon_virtual_currency"];
}


@end
