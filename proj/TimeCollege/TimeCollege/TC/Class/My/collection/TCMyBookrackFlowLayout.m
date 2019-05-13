//
//  TCMyBookrackFlowLayout.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackFlowLayout.h"

@implementation TCMyBookrackFlowLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        CGSize ss = [UIScreen mainScreen].bounds.size;
        self.itemSize = CGSizeMake(ss.width / 3, 200);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}

@end
