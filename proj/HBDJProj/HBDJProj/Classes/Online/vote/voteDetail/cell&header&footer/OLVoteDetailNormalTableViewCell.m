//
//  OLVoteDetailNormalTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailNormalTableViewCell.h"
#import "OLVoteDetailModel.h"


static NSString * statusKey = @"status";

@interface OLVoteDetailNormalTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation OLVoteDetailNormalTableViewCell

- (IBAction)voteClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    
}

- (void)setModel:(OLVoteDetailModel *)model{
    [super setModel:model];
    _content.text = model.options;
    
    [model addObserver:self forKeyPath:statusKey options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:statusKey] && object == self.model) {
        if (self.model.status == VoteModelStatusVoted || self.model.status == VoteModelStatusSelected) {
            _content.textColor = [UIColor EDJMainColor];
            _voteBtn.selected = YES;
            self.backgroundColor = [UIColor EDJGrayscale_FA];
        }else{
            _content.textColor = [UIColor blackColor];
            _voteBtn.selected = NO;
            self.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:statusKey];
}

@end
