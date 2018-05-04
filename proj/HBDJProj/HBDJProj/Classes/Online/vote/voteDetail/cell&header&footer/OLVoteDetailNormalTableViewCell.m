//
//  OLVoteDetailNormalTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailNormalTableViewCell.h"
#import "OLVoteDetailModel.h"

@interface OLVoteDetailNormalTableViewCell ()
@property (strong,nonatomic) OLVoteDetailModel *subModel;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation OLVoteDetailNormalTableViewCell

- (void)setModel:(OLVoteDetailModel *)model{
    _subModel = model;
    if (model.status == VoteModelStatusVoted || model.status == VoteModelStatusSelected) {
        _content.textColor = [UIColor EDJMainColor];
        _voteBtn.selected = YES;
        self.backgroundColor = [UIColor EDJGrayscale_FA];
    }else{
        _content.textColor = [UIColor blackColor];
        _voteBtn.selected = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (IBAction)voteClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_voteBtn cutBorderWithBorderWidth:1 borderColor:[UIColor EDJGrayscale_B0] cornerRadius:_voteBtn.width / 2];
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [_voteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_voteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
}


@end
