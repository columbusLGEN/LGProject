//
//  ECRBiRecoCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBiRecoCollectionViewCell.h"
#import "ECRRecoBook.h"

@interface ECRBiRecoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImg;
@property (weak, nonatomic) IBOutlet UILabel *bName;
@property (weak, nonatomic) IBOutlet UILabel *bPrice;
@property (weak, nonatomic) IBOutlet UILabel *bPriceNum;
@property (weak, nonatomic) IBOutlet UIImageView *icon_coin;


@end

@implementation ECRBiRecoCollectionViewCell

- (IBAction)clickRecoBook:(UIButton *)sender {
//    NSDictionary *dict = @{ECRBiRecoBookClickNotificationKey:self.model};
//    [[NSNotificationCenter defaultCenter] postNotificationName:ECRBiRecoBookClickNotification object:nil userInfo:dict];
    if ([self.delegate respondsToSelector:@selector(birecoBookClick:model:)]) {
        [self.delegate birecoBookClick:self model:self.model];
    }
}

- (void)setModel:(ECRRecoBook *)model{
    _model = model;
    [_bookImg sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPlaceHolderImg];
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        _bName.text = [NSString stringWithFormat:@"%@\n",model.en_bookName];
    }else{
        _bName.text = [NSString stringWithFormat:@"%@\n",model.bookName];
    }
    _bPriceNum.text = [NSString stringWithFormat:@"%.2f",model.price];

}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_icon_coin setImage:[UIImage imageNamed:@"icon_virtual_currency"]];
}

@end
