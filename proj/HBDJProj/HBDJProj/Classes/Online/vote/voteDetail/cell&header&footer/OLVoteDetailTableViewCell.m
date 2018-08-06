//
//  OLVoteDetailTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailTableViewCell.h"
#import "OLVoteDetailModel.h"

@implementation OLVoteDetailTableViewCell

+ (NSString *)cellReuseIdWithModel:(OLVoteDetailModel *)model{
    switch (model.localStatus) {
        case VoteModelStatusNormal:
        case VoteModelStatusSelected:
            return @"OLVoteDetailNormalTableViewCell";
            break;
        case VoteModelStatusVoted:
            return @"OLVoteDetailVotedTableViewCell";
            break;
    }
}
+ (CGFloat)cellHeightWithModel:(OLVoteDetailModel *)model{
    switch (model.localStatus) {
        case VoteModelStatusNormal:
        case VoteModelStatusSelected:
            return 60;
            break;
        case VoteModelStatusVoted:
            return 94;
            break;
    }
}
@end
