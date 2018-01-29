//
//  UFriendInfoCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UFriendInfoCollectionViewCell.h"

@interface UFriendInfoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (weak, nonatomic) IBOutlet UILabel *lblBookName;

@end

@implementation UFriendInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lblBookName.textColor = [UIColor whiteColor];
    _lblBookName.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblBookName.hidden = YES;
}

- (void)dataDidChange
{
    BookModel *book = self.data;
    
    _lblBookName.text = [UserRequest sharedInstance].language ? book.bookName : book.en_bookName;
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
}

@end
