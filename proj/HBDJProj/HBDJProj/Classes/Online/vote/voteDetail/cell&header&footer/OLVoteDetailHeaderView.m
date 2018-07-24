//
//  OLVoteDetailHeaderView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailHeaderView.h"
#import "OLVoteDetailHeaderModel.h"

static NSString *keyPath_totalVotesCount = @"totalVotesCount";

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
    _time.text = model.time;
    _voteDes.text = model.voteDescripetion;
    if (model.status == VoteModelStatusVoted) {
        _totalVotes.hidden = NO;
        _totalVotes.text = [NSString stringWithFormat:@"共%ld票",(long)model.totalVotesCount];
    }else{
        _totalVotes.hidden = YES;
    }
    if ([self.delegate respondsToSelector:@selector(voteDetailHeaderReCallHeight:)]) {
        [self.delegate voteDetailHeaderReCallHeight:self];
    }
    
    [model addObserver:self forKeyPath:keyPath_totalVotesCount options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:keyPath_totalVotesCount] && object == self.model) {
        _totalVotes.text = [NSString stringWithFormat:@"共%ld票",(long)self.model.totalVotesCount];
    }
}

- (CGFloat)headerHeight{
    CGFloat textHeight = [_model.title sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:[UIFont systemFontOfSize:20]].height;
    NSLog(@"计算头部高度_textheight: %f",textHeight);
    return 20 + textHeight + 20 + 15 + 20;
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

- (void)dealloc{
    [_model removeObserver:self forKeyPath:keyPath_totalVotesCount];
}

@end
