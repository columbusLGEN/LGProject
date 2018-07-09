//
//  DJTestScoreListLabel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJTestScoreListLabel.h"

@implementation DJTestScoreListLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
//        NSLog(@"initwithcoder: ");
        [self configUI];
    }
    return self;
}

//- (void)awakeFromNib{
//    [super awakeFromNib];
//    NSLog(@"awakeformnib: ");
//    [self configUI];
//}

- (void)configUI{
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = UIColor.EDJGrayscale_11;
    self.font = [UIFont systemFontOfSize:15];
}

@end
