
//
//  UCRDetailStudentTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRDetailStudentTableViewCell.h"

@interface UCRDetailStudentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgBook;
@property (weak, nonatomic) IBOutlet UILabel *lblBookName;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak, nonatomic) IBOutlet UIView *viewProgressBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthProgressConstraint;

@end

@implementation UCRDetailStudentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configView
{
    _lblBookName.textColor = _lblPercent.textColor = [UIColor cm_blackColor_333333_1];
    _lblBookName.font = [UIFont systemFontOfSize:12.f];
    _lblPercent.font = [UIFont systemFontOfSize:15.f];

    _viewProgressBack.layer.masksToBounds = YES;
    _viewProgressBack.layer.cornerRadius = _viewProgressBack.height/2;
    _viewProgressBack.layer.borderColor = [UIColor cm_orangeColor_FF5910_1].CGColor;
    _viewProgressBack.layer.borderWidth = .5f;
}

- (void)dataDidChange
{
    BookModel *book = [BookModel mj_objectWithKeyValues:self.data];
    
    _lblBookName.text = book.bookName;
    _lblPercent.text = [NSString stringWithFormat:@"%.2f%%", book.read_progress];
    [_imgBook sd_setImageWithURL:[NSURL URLWithString:book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    _widthProgressConstraint.constant = Screen_Width - 110 - 80;
    UIView *frontView = [UIView new];
    CGFloat width = _widthProgressConstraint.constant * book.read_progress / 100;
    frontView.frame = CGRectMake(0, 0, width, _viewProgressBack.height);
    frontView.backgroundColor = [UIColor cm_orangeColor_FF5910_1];
    [_viewProgressBack addSubview:frontView];
}

@end
