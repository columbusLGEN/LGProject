//
//  LGBaseTableView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableView.h"

@implementation LGBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSLog(@"tableview -- %@",self);
                    [self.mj_header endRefreshing];
                });
            }];
        }];
    
    }
    return self;
}

@end
