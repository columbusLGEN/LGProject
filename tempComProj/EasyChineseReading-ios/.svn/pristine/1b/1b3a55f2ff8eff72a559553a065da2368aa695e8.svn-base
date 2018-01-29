//
//  ECRHomeSBVCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRHomeSBVCell.h"
#import "ECRHomeBook.h"

@interface ECRHomeSBVCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *bName;
@property (weak, nonatomic) IBOutlet UILabel *bPrice;
@property (weak, nonatomic) IBOutlet UILabel *bPriceNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *icon_coin;


@end

@implementation ECRHomeSBVCell

- (void)textDependsLauguage{
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        _bName.text = [NSString stringWithFormat:@"%@\n",_model.en_bookName];
    }else{
        _bName.text = [NSString stringWithFormat:@"%@\n",_model.bookName];
    }
}

- (void)setModel:(ECRHomeBook *)model{
    _model = model;
    
    [self textDependsLauguage];
    _bPriceNum.text = [NSString stringWithFormat:@"%.2f",model.price];
    
    [_cover sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPlaceHolderImg];
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
    /// 书籍封面宽度
    CGFloat imgW;
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        imgW = (Screen_Width - 7 * [ECRMultiObject homeBookCoverSpace]) / 6;
    }else{
        imgW = (Screen_Width - 5 * [ECRMultiObject homeBookCoverSpace]) / 4;
    }
    /// 书籍封面高度
    CGFloat imgHeight = imgW / [ECRMultiObject homebcwhRate];
    self.imgHeight.constant = imgHeight;
    [_icon_coin setImage:[UIImage imageNamed:@"icon_virtual_currency"]];
}

@end
