//
//  PBDBottomView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PBDBottomView.h"



@implementation PBDBottomView


- (IBAction)click:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    PBDBottomAction action;
    if (sender.tag == 0) {
        /// 点赞
        action = PBDBottomActionLike;
    }
    if (sender.tag == 1) {
        /// 收藏
        action = PBDBottomActionCollect;
    }
    if (sender.tag == 2) {
        /// 分享
        action = PBDBottomActionShare;
    }
    if ([self.delegate respondsToSelector:@selector(pbdBottomClick:action:)]) {
        [self.delegate pbdBottomClick:self action:action];
    }
}

+ (instancetype)pbdBottom{
    return [[[NSBundle mainBundle] loadNibNamed:@"PBDBottomView" owner:nil options:nil] lastObject];
}


@end
