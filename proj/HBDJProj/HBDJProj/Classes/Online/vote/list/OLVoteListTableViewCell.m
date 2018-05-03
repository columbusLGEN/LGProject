//
//  OLVoteListTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteListTableViewCell.h"
#import "OLVoteListModel.h"

@interface OLVoteListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *vote;


@end

@implementation OLVoteListTableViewCell

- (void)setModel:(OLVoteListModel *)model{
    _model = model;
    _title.text = model.title;
    _time.text = model.testTime;
    if (model.isEnd) {
        _vote.text = @"已结束";
        _vote.textColor = [UIColor EDJGrayscale_C2];
    }else{
        if (model.isVote) {
            _vote.text = @"已投票";
            _vote.textColor = [UIColor EDJGrayscale_66];
        }else{
            _vote.text = @"待投票";
            _vote.textColor = [UIColor EDJColor_57C6FF];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
