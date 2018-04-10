//
//  EDJMicroPartyLessionViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessionViewController.h"
#import "EDJHomeHeaderView.h"
#import "EDJMicroLessonHeaderView.h"
#import <MJRefresh.h>
#import "EDJMicroPartyLessonCell.h"

static NSString * const microPartyLessonCell = @"EDJMicroPartyLessonCell";

@interface EDJMicroPartyLessionViewController ()<
UITableViewDataSource,
UITableViewDelegate
>


@end

@implementation EDJMicroPartyLessionViewController

- (void)setDataType:(EDJHomeDataType)dataType{
    _dataType = dataType;
    [self.tableView reloadData];
}

- (void)configHeaderWithSegment:(NSInteger)segment delegate:(id)delegate{
    if (segment == 0) {
        /// 设置header
        self.tableView.tableHeaderView = [EDJMicroLessonHeaderView mlHeaderViewWithDelegate:delegate frame:CGRectMake(0, 0, kScreenWidth, 128)];
    }else{
        self.tableView.tableHeaderView = nil;
    }
}

- (instancetype)init{
    if (self = [super init]) {
        _microModels  = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            [_microModels addObject:@"B"];
        }
        [self.tableView reloadData];
        
        /// testcode
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
            });
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            for (int i = 0; i < 5; i++) {
//                [_microOrBuildModels addObject:@"a"];
//            }
//            [_tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
            
        }];
        
    }
    return self;
}


#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _microModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroPartyLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:microPartyLessonCell];
    
    return cell;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.dataSource = self;
        UIEdgeInsets insets = UIEdgeInsetsMake([EDJHomeHeaderView headerHeight], 0, 0, 0);
        [_tableView setContentInset:insets];
        _tableView.scrollIndicatorInsets = insets;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[EDJMicroPartyLessonCell class] forCellReuseIdentifier:microPartyLessonCell];
    }
    return _tableView;
}

@end
