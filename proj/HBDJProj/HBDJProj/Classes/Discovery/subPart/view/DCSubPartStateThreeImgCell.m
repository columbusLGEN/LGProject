//
//  DCSubPartStateThreeImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateThreeImgCell.h"
#import "DCSubPartStateModel.h"
#import "LGThreeRightButtonView.h"

@interface DCSubPartStateThreeImgCell ()
@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *leftImg;
@property (weak, nonatomic) UIImageView *midImg;
@property (weak, nonatomic) UIImageView *rightImg;

@end

@implementation DCSubPartStateThreeImgCell

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
        self.seButon.selected = YES;
        
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.left.equalTo(self.seButon.mas_right).offset(marginEight);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
        
    }else{
        [self.seButon removeFromSuperview];
        
        /// 默认值
        [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
    }
    
    [self assiDataWithModel:branchCollectModel];
}

- (void)assiDataWithModel:(DCSubPartStateModel *)model{
    _title.text = model.title;
    
    NSURL *url0;
    NSURL *url1;
    NSURL *url2;
    if (model.imgUrls.count > 2) {
        url0 = [NSURL URLWithString:model.imgUrls[0]];
        url1 = [NSURL URLWithString:model.imgUrls[1]];
        url2 = [NSURL URLWithString:model.imgUrls[2]];
    }
    
    [_leftImg sd_setImageWithURL:url0 placeholderImage:DJPlaceholderImage];
    [_midImg sd_setImageWithURL:url1 placeholderImage:DJPlaceholderImage];
    [_rightImg sd_setImageWithURL:url2 placeholderImage:DJPlaceholderImage];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    /// 保证图片的宽高比为 16 : 9 = 1.77
//    NSLog(@"self.leftImg.width: %f",self.leftImg.width);
//    [_leftImg mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(self.leftImg.width / 1.77);
//    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *title = UILabel.new;
        _title = title;
        _title.numberOfLines = 0;
        [self.contentView addSubview:_title];
        
        UIImageView *leftImg = UIImageView.new;
        _leftImg = leftImg;
        [self.contentView addSubview:_leftImg];
        
        UIImageView *midImg = UIImageView.new;
        _midImg = midImg;
        [self.contentView addSubview:_midImg];
        
        UIImageView *rightImg = UIImageView.new;
        _rightImg = rightImg;
        [self.contentView addSubview:_rightImg];
        
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
//            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginFifteen);
            make.height.mas_equalTo(17);
        }];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
        
        [_leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTwelve);
            make.right.equalTo(_midImg.mas_left).offset(-marginFifteen);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(marginTen);
            make.height.mas_equalTo((133 * kScreenHeight) / 1024);
            make.bottom.equalTo(self.boInterView.mas_top).offset(-marginTen);
        }];
        
        [_midImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(_leftImg.mas_width);
            make.height.equalTo(_leftImg.mas_height);
            make.bottom.equalTo(_leftImg.mas_bottom);
        }];

        [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_midImg.mas_right).offset(marginFifteen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTwelve);
            make.width.equalTo(_leftImg.mas_width);
            make.height.equalTo(_leftImg.mas_height);
            make.bottom.equalTo(_leftImg.mas_bottom);
        }];
        
    }
    return self;
}

@end
