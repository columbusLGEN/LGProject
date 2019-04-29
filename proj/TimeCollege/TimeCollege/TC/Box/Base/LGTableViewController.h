//
//  LGTableViewController.h
//  youbei
//
//  Created by Peanut Lee on 2019/2/28.
//  Copyright © 2019 libc. All rights reserved.
//

#import "LGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGTableViewController : LGBaseViewController <
UITableViewDelegate,
UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic,nullable) NSArray *array;
@property (assign, nonatomic) NSInteger currentPage; // 当前页

- (void)headerRefresh;
- (void)footerRefresh;
- (void)stopRefreshAnimate;

@end

NS_ASSUME_NONNULL_END
