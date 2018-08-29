//
//  DJShowThmemeMeetingNormalTextCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJShowThmemeMeetingNormalTextCell.h"
#import "DJOnlineUploadTableModel.h"

@interface DJShowThmemeMeetingNormalTextCell ()
@property (weak,nonatomic) UILabel *contentLabel;

@end

@implementation DJShowThmemeMeetingNormalTextCell

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    self.contentLabel.text = model.content;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *label = UILabel.new;
        _contentLabel = label;
        [self.contentView addSubview:_contentLabel];
        /// 默认显示 灰色字体，提示用户
        _contentLabel.numberOfLines = 0;
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.textColor = UIColor.EDJGrayscale_11;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginEight);
            make.right.equalTo(self.contentView.mas_right).offset(-marginEight);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginFifteen);
        }];
        
        [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.top.equalTo(_contentLabel.mas_top);
        }];
        
    }
    return self;
}

@end
