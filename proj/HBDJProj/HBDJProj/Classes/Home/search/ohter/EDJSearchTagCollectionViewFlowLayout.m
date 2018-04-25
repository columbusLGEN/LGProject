//
//  EDJSearchTagCollectionViewFlowLayout.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJSearchTagCollectionViewFlowLayout.h"

@interface EDJSearchTagCollectionViewFlowLayout ()


@end

@implementation EDJSearchTagCollectionViewFlowLayout



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(kScreenWidth / 3, 75);
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        
    }
    return self;
}


@end
