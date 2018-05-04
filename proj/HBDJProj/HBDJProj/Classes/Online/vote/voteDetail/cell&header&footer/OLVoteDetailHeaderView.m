//
//  OLVoteDetailHeaderView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailHeaderView.h"
#import "OLVoteDetailHeaderModel.h"

@interface OLVoteDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *voteDes;
@property (weak, nonatomic) IBOutlet UILabel *totalVotes;


@end

@implementation OLVoteDetailHeaderView

- (void)setModel:(OLVoteDetailHeaderModel *)model{
    _model = model;
    _title.text = model.title;
    _time.text = model.testTime;
    _voteDes.text = model.voteDescripetion;
    if (model.status == VoteModelStatusVoted) {
        _totalVotes.hidden = NO;
        _totalVotes.text = [NSString stringWithFormat:@"共%ld票",model.totalVotesCount];
    }else{
        _totalVotes.hidden = YES;
    }
}

- (void)setupUI{
    _title.textColor = [UIColor EDJColor_0D96F6];
    _time.textColor = [UIColor EDJGrayscale_66];
    _voteDes.textColor = [UIColor EDJGrayscale_33];
    _totalVotes.textColor = [UIColor EDJMainColor];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

+ (instancetype)headerForVoteDetail{
    return [[[NSBundle mainBundle] loadNibNamed:@"OLVoteDetailHeaderView" owner:nil options:nil] lastObject];
}

@end
