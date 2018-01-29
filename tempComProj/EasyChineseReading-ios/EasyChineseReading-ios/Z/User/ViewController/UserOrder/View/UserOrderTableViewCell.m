//
//  OrderTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserOrderTableViewCell.h"

@interface UserOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *viewBackground;  // 信息背景（为了边框）
@property (weak, nonatomic) IBOutlet UIView *coverLine;       // 虚线

@property (weak, nonatomic) IBOutlet UILabel *lblBookName;    // 书名
@property (weak, nonatomic) IBOutlet UILabel *lblBookCost;    // 钱
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;      // 作者

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCoverPic; // 图书封面
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurr;

@property (weak, nonatomic) IBOutlet UIButton *btnReading;

@property (strong, nonatomic) BookModel *book;

@end

@implementation UserOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configOrderListTableViewCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configOrderListTableViewCell
{
    _lblBookName.textColor = [UIColor cm_blackColor_333333_1];
    _lblAuthor.textColor   = [UIColor cm_blackColor_666666_1];
    _lblBookCost.textColor = [UIColor cm_orangeColor_FF5910_1];
    
    _lblBookName.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblAuthor.font   = [UIFont systemFontOfSize:cFontSize_14];
    _lblBookCost.font = [UIFont systemFontOfSize:cFontSize_16];
    
    [_btnReading setTitle:LOCALIZATION(@"立即阅读") forState:UIControlStateNormal];
    [_btnReading setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    _btnReading.hidden = YES;
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBookDetail)];
    _imgBookCoverPic.userInteractionEnabled = YES;
    [_imgBookCoverPic addGestureRecognizer:tapImg];
    
    _imgVirtualCurr.image = [UIImage imageNamed:@"icon_virtual_currency"];
}

- (void)dataDidChange
{
    [self sizeToFit];
    OrderModel *order = self.data;
    _book = [BookModel mj_objectWithKeyValues:[order.books objectAtIndex:_index]];

    BOOL isCN = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese;
    _lblBookName.text = isCN ? _book.bookName : _book.en_bookName;
    _lblAuthor.text   = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"), isCN ? _book.author : _book.en_author];
    _lblBookCost.text = [NSString stringWithFormat:@"%.2f", _book.price];
    [_imgBookCoverPic sd_setImageWithURL:[NSURL URLWithString:_book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    
    _btnReading.hidden = order.orderStatus != ENUM_ZOrderStateDone && order.orderStatus != ENUM_ZOrderStateScore;
    
    [UIView drawDashLine:_coverLine lineLength:3 lineSpacing:1 lineColor:[UIColor cm_lineColor_D9D7D7_1]];
}

/** 到订单详情 */
- (void)tapToBookDetail
{
    if ([self.delegate respondsToSelector:@selector(toBookDetailWithBook:)]) {
        [self.delegate toBookDetailWithBook:_book];
    }
}


/** 立即阅读 */
- (IBAction)click_btnReading:(id)sender {
    if ([self.delegate respondsToSelector:@selector(readBookWithBook:)]) {
        [self.delegate readBookWithBook:_book];
    }
}

@end
