//
//  UCMemberStageTransitionButton.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMemberStageTransitionButton.h"

@implementation UCMemberStageTransitionButton

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.img mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.width.mas_equalTo((kScreenWidth - 100) / 4);
        make.height.mas_equalTo(91);
    }];
    [self.textButton.titleLabel setFont:[UIFont systemFontOfSize:19]];
}

@end
