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
    if (model.votestatus == 1) {
        _vote.text = @"已投票";
        _vote.textColor = [UIColor EDJGrayscale_66];
    }else if (model.votestatus == 0){
        _vote.text = @"待投票";
        _vote.textColor = [UIColor EDJColor_57C6FF];
    }else if(model.votestatus == 3){
        _vote.text = @"已结束";
        _vote.textColor = [UIColor EDJGrayscale_C2];
    }else{
        /// 未开始
        
    }
    _title.text = model.title;
    _time.text = model.starttime;
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
