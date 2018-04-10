//
//  LIGCollectionViewFlowLayout.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LIGCollectionViewFlowLayout.h"

@implementation LIGCollectionViewFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.itemSize = CGSizeMake(102, 133);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

@end
