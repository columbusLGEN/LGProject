//
//  OLVoteDetailVotedTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailVotedTableViewCell.h"
#import "OLVoteDetailModel.h"

@interface OLVoteDetailVotedTableViewCell ()
@property (strong,nonatomic) OLVoteDetailModel *subModel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIProgressView *voteRate;
@property (weak, nonatomic) IBOutlet UILabel *voteCount;

@end

@implementation OLVoteDetailVotedTableViewCell

- (void)setModel:(OLVoteDetailModel *)model{
    _subModel = model;
    
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
