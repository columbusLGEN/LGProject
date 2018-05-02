//
//  UCUploadCollectionViewFlowLayout.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadCollectionViewFlowLayout.h"

@implementation UCUploadCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.itemSize;
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}

@end
