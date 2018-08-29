//
//  DJUcMyCollectLessonCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectLessonCell.h"
#import "DJUcMyCollectLessonModel.h"

@interface DJUcMyCollectLessonCell ()
@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *pcIcon;
@property (weak, nonatomic) UILabel *peopleCount;
@property (weak, nonatomic) UIImageView *tiIcon;
@property (weak, nonatomic) UILabel *time;
@property (weak, nonatomic) UIImageView *img;

@end

@implementation DJUcMyCollectLessonCell

- (void)setCollectModel:(DJUcMyCollectLessonModel *)collectModel{
    [super setCollectModel:collectModel];
    if (collectModel.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.title.mas_top).offset(3);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.seButon.mas_right).offset(marginEight);
            make.top.equalTo(self.img.mas_top);
            make.right.equalTo(self.img.mas_left).offset(-marginTen);
        }];
        self.seButon.selected = collectModel.select;
        
    }else{
        [self.seButon removeFromSuperview];
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.top.equalTo(self.img.mas_top);
            make.right.equalTo(self.img.mas_left).offset(-marginTen);
        }];
    }
    
    _title.text = collectModel.title;
    _peopleCount.text = collectModel.plCountString;
    _time.text = collectModel.createdDate;
    [_img sd_setImageWithURL:collectModel.coverUrl placeholderImage:DJPlaceholderImage];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *title = UILabel.new;
        _title = title;
        [self.contentView addSubview:_title];
        
        UIImageView *pcIcon = UIImageView.new;
        _pcIcon = pcIcon;
        [self.contentView addSubview:_pcIcon];
        
        UILabel *peopleCount = UILabel.new;
        _peopleCount = peopleCount;
        [self.contentView addSubview:_peopleCount];
        
        UIImageView *tiIcon = UIImageView.new;
        _tiIcon = tiIcon;
        [self.contentView addSubview:_tiIcon];
        
        UILabel *time = UILabel.new;
        _time = time;
        [self.contentView addSubview:time];
        
        UIImageView *img = UIImageView.new;
        _img = img;
        [self.contentView addSubview:_img];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.top.equalTo(self.img.mas_top);
            make.right.equalTo(self.img.mas_left).offset(-marginTen);
            
        }];
        
        [_pcIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title);
            make.bottom.equalTo(self.img).offset(marginFive);
            make.width.mas_equalTo(marginFifteen);
            make.height.mas_equalTo(marginFifteen);
        }];
        
        [_peopleCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pcIcon.mas_right).offset(marginFive);
            make.centerY.equalTo(self.pcIcon);
            make.width.mas_equalTo(50);
        }];
        
        [_tiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.peopleCount.mas_right).offset(marginTwenty);
            make.centerY.equalTo(self.pcIcon);
            make.width.mas_equalTo(marginFifteen);
            make.height.mas_equalTo(marginFifteen);
        }];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tiIcon.mas_right).offset(marginFive);
            make.centerY.equalTo(self.pcIcon);
            make.right.equalTo(self.img.mas_left).offset(-marginTen);
//            make.width.mas_equalTo(135);
        }];
        
        CGFloat imgHeight = 67 * rateForMicroLessonCellHeight();
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imgHeight);
            make.width.mas_equalTo(rate16_9() * imgHeight);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
        }];
        
        UIView *line = UIView.new;
        line.backgroundColor = UIColor.EDJGrayscale_F3;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
        
        _title.numberOfLines = 2;
        
        _pcIcon.image = [UIImage imageNamed:@"home_micro_sub_cell_people_count"];
        
        _tiIcon.image = [UIImage imageNamed:@"home_micro_sub_cell_time"];
        
    }
    return self;
}

@end
