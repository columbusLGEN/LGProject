//
//  TCBIMessageCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/19.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBIMessageCell.h"

@interface TCBIMessageCell ()
/** "教材分类" */
@property (strong,nonatomic) UILabel *bookCatagory_prefix;
/** 教材分类 */
@property (strong,nonatomic) UILabel *bookCatagory;
/** "学段" */
@property (strong,nonatomic) UILabel *school_prefix;
/** 学段 */
@property (strong,nonatomic) UILabel *school;
/** 年级 */
@property (strong,nonatomic) UILabel *grade;
/** 册别 */
@property (strong,nonatomic) UILabel *cebie;

@end

@implementation TCBIMessageCell

- (void)setModel:(id)model{
    [super setModel:model];
    self.itemName.text = @"教材信息";
    _bookCatagory.text = @"传统文化.黄梅戏开";
    _school.text = @"小学";
    _grade.text = @"年级：三年级";
    _cebie.text = @"册别：上册";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bookCatagory_prefix];
        [self.contentView addSubview:self.bookCatagory];
        [self.contentView addSubview:self.school_prefix];
        [self.contentView addSubview:self.school];
        [self.contentView addSubview:self.grade];
        [self.contentView addSubview:self.cebie];
        
        [self.bookCatagory_prefix mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(17);
            make.top.equalTo(self.itemName.mas_bottom).offset(8);
            make.left.equalTo(self.itemName.mas_left);
        }];
        [self.bookCatagory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bookCatagory_prefix);
            make.left.equalTo(self.bookCatagory_prefix.mas_right).offset(2);
            make.right.equalTo(self.grade.mas_left).offset(-16);
        }];
        [self.school_prefix mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(17);
            make.top.equalTo(self.bookCatagory_prefix.mas_bottom).offset(8);
            make.right.equalTo(self.bookCatagory_prefix.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        }];
        [self.school mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.school_prefix.mas_centerY);
            make.left.equalTo(self.school_prefix.mas_right).offset(2);
        }];
        [self.grade mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.width.mas_equalTo(130);
            make.centerY.equalTo(self.bookCatagory_prefix);
        }];
        [self.cebie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.grade);
            make.centerY.equalTo(self.school);
        }];
        
    }
    return self;
}

- (UILabel *)bookCatagory_prefix{
    if (!_bookCatagory_prefix) {
        _bookCatagory_prefix = UILabel.new;
        _bookCatagory_prefix.font = [UIFont systemFontOfSize:14];
        _bookCatagory_prefix.textColor = UIColor.YBColor_6A6A6A;
        _bookCatagory_prefix.text = @"教材分类：";
        _bookCatagory_prefix.textAlignment = NSTextAlignmentRight;
    }
    return _bookCatagory_prefix;
}
- (UILabel *)bookCatagory{
    if (!_bookCatagory) {
        _bookCatagory = UILabel.new;
        _bookCatagory.font = [UIFont systemFontOfSize:14];
        _bookCatagory.textColor = UIColor.YBColor_6A6A6A;

    }
    return _bookCatagory;
}
- (UILabel *)school_prefix{
    if (!_school_prefix) {
        _school_prefix = UILabel.new;
        _school_prefix.font = [UIFont systemFontOfSize:14];
        _school_prefix.textColor = UIColor.YBColor_6A6A6A;
        _school_prefix.text = @"学段：";
        _school_prefix.textAlignment = NSTextAlignmentRight;
    }
    return _school_prefix;
}
- (UILabel *)school{
    if (!_school) {
        _school = UILabel.new;
        _school.font = [UIFont systemFontOfSize:14];
        _school.textColor = UIColor.YBColor_6A6A6A;
        
    }
    return _school;
}
- (UILabel *)grade{
    if (!_grade) {
        _grade = UILabel.new;
        _grade.font = [UIFont systemFontOfSize:14];
        _grade.textColor = UIColor.YBColor_6A6A6A;
        
    }
    return _grade;
}
- (UILabel *)cebie{
    if (!_cebie) {
        _cebie = UILabel.new;
        _cebie.font = [UIFont systemFontOfSize:14];
        _cebie.textColor = UIColor.YBColor_6A6A6A;
        
    }
    return _cebie;
}


@end
