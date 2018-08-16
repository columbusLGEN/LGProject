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
