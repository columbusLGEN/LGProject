//
//  DJThoutghtRepotListTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoutghtRepotListTableViewCell.h"
#import "DJThoutghtRepotListModel.h"

@interface DJThoutghtRepotListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeading;

@end

@implementation DJThoutghtRepotListTableViewCell

- (void)setModel:(DJThoutghtRepotListModel *)model{
    _model = model;
    
    [self assiDataWithModel:model];
}

- (void)setUcmuModel:(DJThoutghtRepotListModel *)ucmuModel{
    _ucmuModel = ucmuModel;
    [self assiDataWithModel:ucmuModel];
    if (ucmuModel.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.title.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        self.seButon.selected = ucmuModel.select;
        self.titleLeading.constant = 38;
        
    }else{
        [self.seButon removeFromSuperview];
        self.titleLeading.constant = 15;
    }
    
}

- (void)assiDataWithModel:(DJThoutghtRepotListModel *)model{
    _title.text = model.title;
    if (model.createdtime.length > length_timeString_1) {
        _time.text = [model.createdtime substringToIndex:(length_timeString_1 + 1)];
    }else{
        _time.text = model.createdtime;
    }
    _author.text = [@"上传者: " stringByAppendingString:model.uploader];
    [_image sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
}

@end
