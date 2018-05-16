//
//  LGButton.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGButton.h"



@implementation LGButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageEdgeInsets = UIEdgeInsetsMake(-2, -10, 0, 0);
        self.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self setTitleColor:[UIColor EDJGrayscale_33] forState:UIControlStateNormal];
    }
    return self;
}

@end
