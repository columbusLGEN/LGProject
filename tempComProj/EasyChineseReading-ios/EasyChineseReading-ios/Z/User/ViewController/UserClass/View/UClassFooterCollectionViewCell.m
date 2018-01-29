//
//  UClassFooterCollectionViewCell.m
//  
//
//  Created by 赵春阳 on 2017/10/11.
//

#import "UClassFooterCollectionViewCell.h"

@interface UClassFooterCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (weak, nonatomic) IBOutlet UILabel *lblBookName;
@property (weak, nonatomic) IBOutlet UILabel *lblBookPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@end

@implementation UClassFooterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

- (void)configCell
{
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
    _lblBookName.textColor  = [UIColor cm_blackColor_333333_1];
    _lblBookPrice.textColor = [UIColor cm_orangeColor_FF5910_1];
    
    _lblBookName.font  = [UIFont systemFontOfSize:cFontSize_14];
    _lblBookPrice.font = [UIFont systemFontOfSize:cFontSize_14];
}

- (void)dataDidChange
{
    BookModel *book = self.data;
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", book.iconUrl]] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    _lblBookName.text  = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? book.bookName : book.en_bookName;
    _lblBookPrice.text = [NSString stringWithFormat:@"%.2f", book.price];
}

@end
