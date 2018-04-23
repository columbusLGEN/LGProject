//
//  EDJLevelInfoFlowLayout.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJLevelInfoFlowLayout.h"

@implementation EDJLevelInfoFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        /// 实例位于 storyboard 中 执行了该方法
        [self customConfig];
    }
    return self;
}

- (void)customConfig{
    CGFloat itemW = (kScreenWidth - 20) / 2;
    CGFloat itemH = 87 + 30;
    self.itemSize = CGSizeMake(itemW, itemH);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
}

@end
