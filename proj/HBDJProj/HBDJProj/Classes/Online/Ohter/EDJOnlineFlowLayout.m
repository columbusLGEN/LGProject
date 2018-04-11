//
//  EDJOnlineFlowLayout.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJOnlineFlowLayout.h"

@implementation EDJOnlineFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.itemSize = CGSizeMake(kScreenWidth * 0.333, 105);
//        self.minimumLineSpacing = 0;/// 竖直方向
        self.minimumInteritemSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

@end
