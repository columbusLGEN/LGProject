//
//  ECRBooksSelectedTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRBooksSelectedTableViewCell.h"

@interface UCRBooksSelectedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblBookName; // 选中图书的书名
@property (weak, nonatomic) IBOutlet UIImageView *imgDelete;

@end

@implementation UCRBooksSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self configBookSelectedCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 配置界面

- (void)configBookSelectedCell
{
    _lblBookName.textColor = [UIColor cm_blackColor_333333_1];
    _lblBookName.font = [UIFont systemFontOfSize:15.f];
    
    _imgDelete.image = [UIImage imageNamed:@"icon_class_delete"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_UnSelectedBook:)];
    _imgDelete.userInteractionEnabled = YES;
    [_imgDelete addGestureRecognizer:tap];
}

#pragma mark - 赋值

- (void)dataDidChange
{
    BookModel *book = self.data;
    _lblBookName.text = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? book.bookName : book.en_bookName;
}

/** 删除选中的数据 */
- (void)click_UnSelectedBook:(id)sender {
    [self.delegate removeSelectedBook:self.data];
}

@end
