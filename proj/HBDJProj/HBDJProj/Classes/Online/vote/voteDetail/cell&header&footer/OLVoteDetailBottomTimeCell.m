//
//  OLVoteDetailBottomTimeCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailBottomTimeCell.h"

@interface OLVoteDetailBottomTimeCell ()
@property (weak,nonatomic) UILabel *endTimeLabel;

@end

@implementation OLVoteDetailBottomTimeCell

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    /// 精确到分钟
    _endTimeLabel.text = [@"结束时间: " stringByAppendingString:endTime];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *line = UIView.new;
        line.backgroundColor = UIColor.EDJGrayscale_F3;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(marginFive);
        }];
        
        UILabel *lbl = UILabel.new;
        _endTimeLabel = lbl;
        [self.contentView addSubview:_endTimeLabel];
        [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(marginEight);
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-13);
        }];
    }
    return self;
}


@end
