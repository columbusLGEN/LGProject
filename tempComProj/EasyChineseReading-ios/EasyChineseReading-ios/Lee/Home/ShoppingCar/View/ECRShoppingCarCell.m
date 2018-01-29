//
//  ECRShoppingCarCell.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRShoppingCarCell.h"
#import "ECRShoppingCarModel.h"

@interface ECRShoppingCarCell ()
@property (weak,nonatomic) IBOutlet UIButton *tick;// 勾选按钮
@property (weak, nonatomic) IBOutlet UIImageView *bookCover;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookPrice;
@property (weak, nonatomic) IBOutlet UIView *diLine;
@property (weak, nonatomic) IBOutlet UILabel *bookPriceNum;
@property (weak, nonatomic) IBOutlet UIImageView *coinIcon;


@end

@implementation ECRShoppingCarCell

- (IBAction)selectProduct:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(scCell:selectProduct:)]) {
        [self.delegate scCell:self selectProduct:self.model];
    }
}

- (void)setModel:(ECRShoppingCarModel *)model{
    _model = model;
    // MARK: 设置数据
    [_bookCover sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPlaceHolderImg];
    
    if ([LGPChangeLanguage currentLanguageIsEnglish]) {
        _bookName.text = model.en_bookName;
        _bookAuthor.text = model.en_author;
    }else{
        _bookName.text = model.bookName;
        _bookAuthor.text = model.author;
    }
    
    _bookPriceNum.text = [NSString stringWithFormat:@"%.2f",model.price];
    _tick.selected = model.isTick;
    NSLog(@"%@: %d",model.bookName,model.isTick);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_tick setImage:[UIImage imageNamed:@"icon_selected_no"] forState:UIControlStateNormal];
    [_tick setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
    [_coinIcon setImage:[UIImage imageNamed:@"icon_virtual_currency"]];
    _bookCover.clipsToBounds = YES;
    _bookCover.contentMode = UIViewContentModeScaleAspectFill;
//    NSLog(@"tickedbutton -- %@",self.tick);
}


@end
