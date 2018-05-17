//
//  DCSubPartStateDetailHeader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateDetailHeader.h"

@interface DCSubPartStateDetailHeader ()


@end

@implementation DCSubPartStateDetailHeader



- (void)setupUI{
    self.backgroundColor = [UIColor randomColor];

}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


@end
