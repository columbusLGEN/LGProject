//
//  LGBaseCollectionView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseCollectionView.h"

@implementation LGBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
//        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.mj_header endRefreshing];
//                    [self reloadData];
//                });
//            }];
//        }];
    }
    return self;
}

@end
