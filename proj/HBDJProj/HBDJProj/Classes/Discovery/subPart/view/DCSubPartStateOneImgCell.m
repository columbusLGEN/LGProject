//
//  DCSubPartStateOneImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateOneImgCell.h"
#import "DCSubPartStateModel.h"

@interface DCSubPartStateOneImgCell ()
@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *img;


@end

@implementation DCSubPartStateOneImgCell

- (void)setModel:(DCSubPartStateModel *)model{
    [super setModel:model];
    [self assiDataWithModel:model];

}

- (void)setBranchCollectModel:(DCSubPartStateModel *)branchCollectModel{
    [super setBranchCollectModel:branchCollectModel];
    
    if (branchCollectModel.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.title.mas_top).offset(2);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        self.seButon.selected = branchCollectModel.select;
        
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.seButon.mas_right).offset(marginEight);
            make.top.equalTo(_img.mas_top);
            make.right.equalTo(_img.mas_left).offset(-marginEight);
        }];
    }else{
        [self.seButon removeFromSuperview];
        
        /// 默认值
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.top.equalTo(_img.mas_top);
            make.right.equalTo(_img.mas_left).offset(-marginEight);
            //            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
    }
    
    [self assiDataWithModel:branchCollectModel];
}

- (void)assiDataWithModel:(DCSubPartStateModel *)model{
    [_img sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
    _title.text = model.title;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        /// 标题
        UILabel *title = UILabel.new;
        _title = title;
        title.numberOfLines = 2;
        [self.contentView addSubview:_title];
        
        /// 封面图片
        UIImageView *img = UIImageView.new;
        _img = img;
        [self.contentView addSubview:_img];
        
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.top.equalTo(_img.mas_top);
            make.right.equalTo(_img.mas_left).offset(-marginEight);
//            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
        
        // TODO: Zup_长宽比16：9; 133 --> 90
        CGFloat imgH = 90 * kScreenHeight / 1024.f;
        CGFloat imgW = imgH * 16 / 9.f;
    
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(imgW);
            make.height.mas_equalTo(imgH);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.bottom.equalTo(self.timeLabel.mas_bottom);
        }];
    }
    return self;
}

@end
