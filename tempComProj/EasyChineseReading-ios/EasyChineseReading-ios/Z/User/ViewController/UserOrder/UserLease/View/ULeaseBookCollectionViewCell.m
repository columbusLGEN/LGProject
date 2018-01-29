//
//  ULeaseBookCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/28.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ULeaseBookCollectionViewCell.h"

@interface ULeaseBookCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imgBookCover; // 图书封面
@property (strong, nonatomic) UILabel *lblBookName;      // 图书名
@property (strong, nonatomic) UILabel *lblBookPrice;     // 价格
@property (strong, nonatomic) UIImageView *imgPrice;     // 元宝

@end

@implementation ULeaseBookCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configBookCell];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - 配置界面

- (void)configBookCell
{
    self.backgroundColor = [UIColor whiteColor];
    
    _imgBookCover = [UIImageView new];
    _imgBookCover.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_imgBookCover];
    
    _imgPrice = [UIImageView new];
    _imgPrice.contentMode = UIViewContentModeScaleAspectFill;
    _imgPrice.image = [UIImage imageNamed:@"icon_virtual_currency"];
    [self addSubview:_imgPrice];
    
    _lblBookName = [UILabel new];
    _lblBookName.font = [UIFont systemFontOfSize:cFontSize_12];
    _lblBookName.textColor = [UIColor blackColor];
    _lblBookName.textAlignment = NSTextAlignmentLeft;
    _lblBookName.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblBookName.numberOfLines = 2;
    [self addSubview:_lblBookName];
    
    _lblBookPrice = [UILabel new];
    _lblBookPrice.font = [UIFont systemFontOfSize:cFontSize_12];
    _lblBookPrice.textAlignment = NSTextAlignmentLeft;
    _lblBookPrice.textColor = [UIColor cm_orangeColor_FF5910_1];
    [self addSubview:_lblBookPrice];
    
    [_imgBookCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-50.f);
    }];
    
    [_lblBookName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_imgBookCover.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left);
    }];
    
    [_imgPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(_lblBookPrice.mas_centerY);
    }];
    
    [_lblBookPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgPrice.mas_right).offset(5);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark - 更新数据

- (void)dataDidChange
{
    BookModel *book = [BookModel mj_objectWithKeyValues:self.data];
    [_imgBookCover sd_setImageWithURL:[NSURL URLWithString:book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    _lblBookName.text = book.bookName;
    _lblBookPrice.text = [NSString stringWithFormat:@"%.2f", book.price];
}

@end
