//
//  TCBIContentCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBIContentCell.h"

@interface TCBIContentCell ()
@property (strong,nonatomic) UILabel *con;

@end

@implementation TCBIContentCell

- (void)setModel:(id)model{
    [super setModel:model];
    self.itemName.text = @"内容简介";
    self.con.text = @"《毛泽东选集》是1944年人民出版社出版的图书，作者是毛泽东。《毛泽东选集》是毛泽东思想的重要载体，是毛泽东思想的集中展现，是对20世纪中国影响最大的书籍之一。建国后两个版本的《毛泽东选集》，均由人民出版社出版。《毛泽东选集》在建国前即有大量出版。自1944年于邯郸创建的晋察冀日报社出版首版《毛泽东选集》。建国后出版的《毛泽东选集》一至四卷，编入的是毛泽东同志在新民主主义革命时期的主要著作。第一版《毛泽东选集》一至四卷，分别于20世纪50年代初和60年代初出版。1991年7月1日，《毛泽东选集》一至四卷第二版正式出版发行。邓小平同志为新版《毛泽东选集》题写了书名。";
}

- (void)conShowAll:(UIButton *)sender{
    /// TODO: 根据模型的状态 修改
    /// 显示全部 or 显示部分（默认5行）
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        self.showAll.transform = CGAffineTransformMakeRotation(M_PI);
        self.con.numberOfLines = 0;
    }else{
        self.showAll.transform = CGAffineTransformIdentity;
        self.con.numberOfLines = 5;
    }
    [self.fatherTableView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.con];
        [self.con mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemName);
            make.top.equalTo(self.itemName.mas_bottom).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        }];
        
        [self.contentView addSubview:self.showAll];
        [self.showAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.top.equalTo(self.con.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.width.height.mas_equalTo(10);
        }];
        
    }
    return self;
}
- (UILabel *)con{
    if (!_con) {
        _con = UILabel.new;
        _con.textColor = UIColor.YBColor_6A6A6A;
        _con.font = [UIFont systemFontOfSize:12];
        _con.numberOfLines = 5;
    }
    return _con;
}

- (UIButton *)showAll{
    if (!_showAll) {
        _showAll = UIButton.new;
        [_showAll setImage:[UIImage imageNamed:@"icon_arrow_down_gray"] forState:UIControlStateNormal];
        [_showAll addTarget:self action:@selector(conShowAll:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showAll;
}

@end
