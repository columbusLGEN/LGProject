//
//  TCListHeaderTableViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCListHeaderTableViewCell.h"
#import "TCBookCatagoryLineModel.h"
#import "TCHeaderCollectionViewController.h"

@interface TCListHeaderTableViewCell ()
@property (strong,nonatomic) UILabel *itemTitle;
@property (strong,nonatomic) TCHeaderCollectionViewController *hcovc;

@end

@implementation TCListHeaderTableViewCell

- (void)setModel:(TCBookCatagoryLineModel *)model{
    _model = model;
    _itemTitle.text = model.itemName;
    self.hcovc.lineModel = model;
    self.hcovc.array = model.bookCata;
    
    if (model.isSecondery) {
        self.contentView.backgroundColor = UIColor.YBColor_E8F3FE;
        [self.hcovc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemTitle.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(25);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom);//.offset(-5);
        }];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.itemTitle];
        [self.contentView addSubview:self.hcovc.view];
        
        [self.itemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        [self.hcovc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemTitle.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(35);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom);//.offset(-5);
        }];
    }
    return self;
}

- (UILabel *)itemTitle{
    if (!_itemTitle) {
        _itemTitle = UILabel.new;
        _itemTitle.font = [UIFont systemFontOfSize:14];
        _itemTitle.textColor = UIColor.YBColor_6A6A6A;
    }
    return _itemTitle;
}

- (TCHeaderCollectionViewController *)hcovc{
    if (!_hcovc) {
        _hcovc = TCHeaderCollectionViewController.new;
    }
    return _hcovc;
}

@end
