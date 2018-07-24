//
//  OLVoteDetailVotedTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailVotedTableViewCell.h"
#import "OLVoteDetailModel.h"

static NSString *keyPath_votecount = @"votecount";


@interface OLVoteDetailVotedTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIProgressView *voteRate;
@property (weak, nonatomic) IBOutlet UILabel *voteCount;

@end

@implementation OLVoteDetailVotedTableViewCell

- (void)setModel:(OLVoteDetailModel *)model{
    [super setModel:model];
    _content.text = model.options;
    _voteCount.text = [NSString stringWithFormat:@"%ld票",(long)model.votecount];
    
    if (model.totalVotesCount == 0) {
        _voteRate.progress = 0.0;
    }else{
        _voteRate.progress = (CGFloat)model.votecount / model.totalVotesCount;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_voteRate cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:4];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _voteCount.textColor = [UIColor EDJMainColor];
    _voteRate.tintColor = [UIColor EDJMainColor];
}


@end
