//
//  UCRecommendBooksTC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendBooksTableViewCell.h"
#import "ECRBookListModel.h"

@interface UCRecommendBooksTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@property (weak, nonatomic) IBOutlet UILabel *lblBookName;
@property (weak, nonatomic) IBOutlet UILabel *lblBookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblBookSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *lblBookMoney;

@property (weak, nonatomic) IBOutlet UIView *viewStar;

@end

@implementation UCRecommendBooksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configCell
{
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
    
    _lblBookName.textColor     = [UIColor cm_blackColor_333333_1];
    _lblBookAuthor.textColor   = [UIColor cm_blackColor_666666_1];
    _lblBookSynopsis.textColor = [UIColor cm_blackColor_666666_1];
    _lblBookMoney.textColor    = [UIColor cm_orangeColor_FF5910_1];
    
    _lblBookName.font     = [UIFont systemFontOfSize:cFontSize_16];
    _lblBookAuthor.font   = [UIFont systemFontOfSize:cFontSize_14];
    _lblBookSynopsis.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblBookMoney.font    = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)dataDidChange
{
    ECRBookListModel *bookModel = self.data;
    
    BOOL isCN = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese;
    _lblBookName.text   = isCN ? bookModel.bookName : bookModel.en_bookName;
    _lblBookAuthor.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"), bookModel.author];
    
    bookModel.startTime = [bookModel.startTime substringToIndex:10];
    bookModel.endTime = [bookModel.endTime substringToIndex:10];
    if (bookModel.startTime.length > 0)
        _lblBookSynopsis.text = [NSString stringWithFormat:@"%@:\n%@ —— %@", LOCALIZATION(@"授权周期"),  bookModel.startTime, bookModel.endTime];
    else
        _lblBookSynopsis.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"简介"), isCN ? bookModel.contentValidity : bookModel.en_contentValidity];
    
    _lblBookMoney.text = [NSString stringWithFormat:@"%.2f", bookModel.price];
    
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:bookModel.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    
    ZStarView *star = [[ZStarView alloc] initWithFrame:CGRectMake(0, 0, _viewStar.width, _viewStar.height) numberOfStar:5];
    star.canChange = NO;
    [_viewStar addSubview:star];
    [star setScore:bookModel.score withAnimation:NO];
    
    self.isSelected = bookModel.isSelected;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _imgSelected.image = isSelected ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
}

@end
