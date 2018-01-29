//
//  UFavouriteTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UFavouriteTableViewCell.h"

@interface UFavouriteTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblBookName;          // 书名
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;            // 作者
@property (weak, nonatomic) IBOutlet UILabel *lblFavouriteNumber;   // 收藏的数量
@property (weak, nonatomic) IBOutlet UILabel *lblFavouriteTime;     // 收藏的时间
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;             // 价格

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover;     // 封面
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;      // 选择
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@property (weak, nonatomic) IBOutlet UIButton *btnShopCar;          // 购物车
@property (weak, nonatomic) IBOutlet UIButton *btnShare;            // 分享
/** 图书属性 */
@property (strong, nonatomic) BookModel *book;

@end

@implementation UFavouriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configFavouriteView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configFavouriteView
{
    _lblBookName.textColor          = [UIColor cm_blackColor_333333_1];
    _lblAuthor.textColor            = [UIColor cm_blackColor_333333_1];
    _lblFavouriteTime.textColor     = [UIColor cm_blackColor_333333_1];
    _lblFavouriteNumber.textColor   = [UIColor cm_blackColor_333333_1];
    _lblMoney.textColor             = [UIColor cm_orangeColor_FF5910_1];
    
    _lblBookName.font           = [UIFont systemFontOfSize:cFontSize_16];
    _lblFavouriteNumber.font    = [UIFont systemFontOfSize:cFontSize_14];
    _lblAuthor.font             = [UIFont systemFontOfSize:cFontSize_14];
    _lblFavouriteTime.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblMoney.font              = [UIFont systemFontOfSize:cFontSize_16];
    
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
    [_btnShare setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
}

#pragma mark - 配置数据

- (void)dataDidChange
{
    _book = self.data;
    
    _lblBookName.text      = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? [NSString stringWithFormat:@"%@", _book.bookName] : [NSString stringWithFormat:@"%@", _book.en_bookName];
    _lblAuthor.text        = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"), [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _book.author : _book.en_author];
    _lblFavouriteTime.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"收藏时间"), [_book.date substringToIndex:10]];
    
    _lblMoney.text = [NSString stringWithFormat:@"%.2f", _book.price];

    _lblFavouriteNumber.text = [NSString stringWithFormat:@"%@: %ld %@", LOCALIZATION(@"收藏人气"), _book.favoriteNum, LOCALIZATION(@"人")];
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:_book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
}

#pragma mark - 选中

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _imgSelected.image = isSelected ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
}

#pragma mark - 分享

- (IBAction)click_btnShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareWithBook:)]) {
        [self.delegate shareWithBook:_book];
    }
}

#pragma mark - 加入购物车

- (IBAction)click_btnShopCar:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addToShopCarWithBook:)]) {
        [self.delegate addToShopCarWithBook:_book];
    }
}

@end
