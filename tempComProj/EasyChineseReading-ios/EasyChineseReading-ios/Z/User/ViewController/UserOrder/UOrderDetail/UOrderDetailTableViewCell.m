//
//  UOrderDetailTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/10.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UOrderDetailTableViewCell.h"

@interface UOrderDetailTableViewCell()<ZStarViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewStar;          // 图书评价
@property (weak, nonatomic) IBOutlet UIView *viewBackground;    // 背景(设置边框)
@property (weak, nonatomic) IBOutlet UIView *viewLine;          // 横线

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover; // 图书封面

@property (weak, nonatomic) IBOutlet UILabel *lblDescScore;     // 描述: 商品评价
@property (weak, nonatomic) IBOutlet UILabel *lblBookName;      // 图书名
@property (weak, nonatomic) IBOutlet UILabel *lblBookAuthor;    // 作者
@property (weak, nonatomic) IBOutlet UILabel *lblBookPrice;     // 价格

@property (weak, nonatomic) BookModel *book;                    // 图书
@property (strong, nonatomic) ZStarView *starView;              // 评星

@end

@implementation UOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configOrderDetailCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateSystemLanguage
{
    _lblDescScore.text = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"商品评价")];
}

- (void)configOrderDetailCell
{
    _viewBackground.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _viewBackground.layer.borderWidth = 1.f;
    
    _viewLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblDescScore.textColor  = [UIColor cm_blackColor_333333_1];
    _lblBookName.textColor   = [UIColor cm_blackColor_333333_1];
    _lblBookAuthor.textColor = [UIColor cm_grayColor__807F7F_1];
    _lblBookPrice.textColor  = [UIColor cm_orangeColor_FF5910_1];
    
    _lblBookName.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblBookPrice.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _starView = [[ZStarView alloc] initWithFrame:_viewStar.bounds numberOfStar:5];
    _starView.delegate = self;
    [_viewStar addSubview:_starView];
    
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBookDetail)];
    _imgBookCover.userInteractionEnabled = YES;
    [_imgBookCover addGestureRecognizer:tapImg];
}

- (void)dataDidChange
{
    _book = self.data;
    if (![_book isKindOfClass:[BookModel class]]) {
        return;
    }
    
    _lblBookName.text = _book.bookName;
    _lblBookAuthor.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"), _book.author];
    
    _lblBookPrice.text = [NSString stringWithFormat:@"%.2f", _book.price];
    
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:_book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    
    _starView.canChange = _canScore;
    [_starView setScore:(_book.userScore > 0 ? _book.userScore : 5) withAnimation:NO];
}

#pragma mark - ZStarViewDelegate
- (void)starRatingView:(ZStarView *)view score:(CGFloat)score
{
    NSNumber *num = [NSNumber numberWithFloat:score];
    NSInteger sc = num.integerValue;
    _book.userScore = sc;
    [self.delegate updateScoreWithScore:sc book:_book];
}

#pragma mark - handle
/** 图书详情 */
- (void)tapToBookDetail
{
    if ([self.delegate respondsToSelector:@selector(toBookDetailWithBook:)]) {
        [self.delegate toBookDetailWithBook:_book];
    }
}

@end
