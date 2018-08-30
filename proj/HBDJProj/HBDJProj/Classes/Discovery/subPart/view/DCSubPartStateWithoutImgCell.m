//
//  DCSubPartStateWithoutImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateWithoutImgCell.h"
#import "DCSubPartStateModel.h"
#import "LGThreeRightButtonView.h"

@interface DCSubPartStateWithoutImgCell ()
@property (weak, nonatomic) UILabel *contentLabel;

@end

@implementation DCSubPartStateWithoutImgCell

- (void)setModel:(DCSubPartStateModel *)model{
    [super setModel:model];
    /// 设置数据
    [self assiDataWithModel:model];
    
}

- (void)setBranchCollectModel:(DCSubPartStateModel *)branchCollectModel{
    [super setBranchCollectModel:branchCollectModel];

    [self assiDataWithModel:branchCollectModel];
    
    if (branchCollectModel.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.contentLabel.mas_top).offset(2);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        self.seButon.selected = branchCollectModel.select;
        self.seButon.selected = YES;
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.seButon.mas_right).offset(marginEight);
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
        
    }else{
        [self.seButon removeFromSuperview];
        
        /// 默认值
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
    }
}

- (void)assiDataWithModel:(DCSubPartStateModel *)model{
    _contentLabel.text = model.title;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *contentLabel = UILabel.new;
        _contentLabel = contentLabel;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-marginTen);
        }];
        
    }
    return self;
}


@end
