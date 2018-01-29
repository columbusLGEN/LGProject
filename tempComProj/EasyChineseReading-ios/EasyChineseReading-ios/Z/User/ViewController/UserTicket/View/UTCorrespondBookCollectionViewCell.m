//
//  UTCorrespondBookCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/24.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UTCorrespondBookCollectionViewCell.h"

@interface UTCorrespondBookCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@property (weak, nonatomic) IBOutlet UILabel *lblBookName;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UIView *viewBottomLine;
@property (weak, nonatomic) IBOutlet UIView *viewRightLine;

@property (weak, nonatomic) IBOutlet UIButton *btnShopCar;

@property (strong, nonatomic) BookModel *book;

@end

@implementation UTCorrespondBookCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configBookCell];
}

- (void)configBookCell
{
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
    _imgBookCover.image = [UIImage imageNamed:@"img_book_placeholder"];
    [_btnShopCar setImage:[UIImage imageNamed:@"icon_shop_car_gray"] forState:UIControlStateNormal];
    
    _viewBottomLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewRightLine.backgroundColor  = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblBookName.textColor = [UIColor cm_blackColor_333333_1];
    _lblAuthor.textColor   = [UIColor cm_blackColor_666666_1];
    _lblDescribe.textColor = [UIColor cm_blackColor_666666_1];
    _lblPrice.textColor    = [UIColor cm_orangeColor_FF5910_1];
    
    _lblBookName.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblAuthor.font   = [UIFont systemFontOfSize:cFontSize_14];
    _lblDescribe.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblPrice.font    = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)dataDidChange
{
    _viewRightLine.hidden = isPad ? _index % 2 == 1 : YES;
    
    _book = self.data;
    
    _lblBookName.text = _book.bookName;
    _lblDescribe.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"内容简介"), _book.contentValidity];
    _lblAuthor.text   = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"), _book.author];
    
    _lblPrice.text = [NSString stringWithFormat:@"%.2f", _book.price];
    
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:_book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
}

- (IBAction)clickBtnAddToShopCar:(id)sender {
    [self.delegate addBookToShopCarWithBook:_book];
}

@end
