//
//  UCRecommendDetailBooksTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/18.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCRecommendDetailBooksTableViewCell.h"

@interface UCRecommendDetailBooksTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (weak, nonatomic) IBOutlet UILabel *lblBookName;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSynopsis;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIView *viewStar;

@property (strong, nonatomic) ZStarView *starView;

@end

@implementation UCRecommendDetailBooksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configBookCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configBookCell
{
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblBookName.textColor = [UIColor cm_blackColor_333333_1];
    _lblAuthor.textColor   = [UIColor cm_blackColor_666666_1];
    _lblSynopsis.textColor = [UIColor cm_blackColor_333333_1];
    _lblPrice.textColor    = [UIColor cm_orangeColor_FF5910_1];
    
    _lblBookName.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblAuthor.font   = [UIFont systemFontOfSize:cFontSize_14];
    _lblSynopsis.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblPrice.font    = [UIFont systemFontOfSize:cFontSize_16];
    
    _starView = [[ZStarView alloc] initWithFrame:_viewStar.bounds numberOfStar:5];
    [_viewStar addSubview:_starView];
}

- (void)dataDidChange
{
    BookModel *book = self.data;
    
    BOOL isCN = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese;
    _lblBookName.text = isCN ? book.bookName : book.en_bookName;
    _lblAuthor.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"), isCN ? book.author : book.en_author];
    _lblSynopsis.text =  [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"简介"), isCN ? book.contentValidity : book.en_contentValidity];
    
    _lblPrice.text = [NSString stringWithFormat:@"%.2f", book.price];
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    
    _starView.canChange = NO;
    [_starView setScore:(book.score > 0 ? book.score : 1) withAnimation:NO];
}

@end
