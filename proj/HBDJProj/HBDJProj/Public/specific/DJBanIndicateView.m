//
//  DJBanIndicateView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJBanIndicateView.h"

@implementation DJBanIndicateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uc_pyq_n_audit"]];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
        }];
    }
    return self;
}

@end
