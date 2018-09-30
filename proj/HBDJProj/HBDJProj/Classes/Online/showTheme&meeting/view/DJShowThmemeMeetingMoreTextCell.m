//
//  DJShowThmemeMeetingMoreTextCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJShowThmemeMeetingMoreTextCell.h"
#import "DJOnlineUploadTableModel.h"

static CGFloat contentFont = 15;

@interface DJShowThmemeMeetingMoreTextCell ()
@property (weak,nonatomic) UILabel *contentLabel;
@property (weak,nonatomic) UIButton *moreButton;
@property (weak,nonatomic) UIImageView *arrow;

@end

@implementation DJShowThmemeMeetingMoreTextCell

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    self.contentLabel.text = model.content;
    
    /// TODO: 计算文本高度，如果小于等于3行： 1.隐藏更多按钮 2.调整约束
//    NSLog(@"self.item.width: %f",self.item.width);
    CGFloat textHeight = [model.content sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 26 - self.item.width, MAXFLOAT) font:[UIFont systemFontOfSize:contentFont]].height;
    
    NSInteger lines = textHeight / 17.9;
    if (lines <= 3) {
        /// 如果不大于 3行，则不显示更多按钮
        _contentLabel.numberOfLines = 3;
        _moreButton.hidden = YES;
        _arrow.hidden = YES;
        
        [_moreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_top).offset(marginTen);
            make.right.equalTo(_arrow.mas_left).offset(-marginFive);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginEight);
            make.height.mas_equalTo(17);
        }];
        
    }else{
        [_moreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(marginEight);
            make.right.equalTo(_arrow.mas_left).offset(-marginFive);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginEight);
            make.height.mas_equalTo(17);
        }];
        _moreButton.selected = model.contentShowAll;
        if (model.contentShowAll) {
            _contentLabel.numberOfLines = 0;
            _arrow.transform = CGAffineTransformMakeRotation(-M_PI);
        }else{
            _contentLabel.numberOfLines = 3;
            _arrow.transform = CGAffineTransformIdentity;
        }
    }
    
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *button = UIButton.new;
        _moreButton = button;
        [self.contentView addSubview:_moreButton];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:UIColor.EDJGrayscale_B0 forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_moreButton setTitle:@"收起" forState:UIControlStateSelected];
        _moreButton.userInteractionEnabled = NO;
        
        UIImageView *imgView = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"home_digital_book_info_arrow_down"]];;
        _arrow = imgView;
        [self.contentView addSubview:_arrow];
        
        UILabel *label = UILabel.new;
        _contentLabel = label;
        [self.contentView addSubview:_contentLabel];
        /// 默认显示 灰色字体，提示用户
        _contentLabel.numberOfLines = 3;
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.textColor = UIColor.EDJGrayscale_11;
        _contentLabel.font = [UIFont systemFontOfSize:contentFont];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginEight);
            make.right.equalTo(self.contentView.mas_right).offset(-marginEight);
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
        }];
        
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(marginEight);
            make.right.equalTo(_arrow.mas_left).offset(-marginFive);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginEight);
            make.height.mas_equalTo(17);
        }];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contentLabel.mas_right);
            make.centerY.equalTo(_moreButton.mas_centerY);
        }];
        
        [self.item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.top.equalTo(_contentLabel.mas_top);
        }];
        
    }
    return self;
}

@end
