//
//  DJUcMyCollectLessonListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectLessonListController.h"
#import "DJUcMyCollectLessonCell.h"
#import "DJUcMyCollectLessonModel.h"
#import "DJUserNetworkManager.h"

@interface DJUcMyCollectLessonListController ()

@end

@implementation DJUcMyCollectLessonListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = homeMicroLessonSubCellBaseHeight * rateForMicroLessonCellHeight();
    [self.tableView registerClass:[DJUcMyCollectLessonCell class] forCellReuseIdentifier:mclCell];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getData{
    [DJUserNetworkManager.sharedInstance frontUserCollections_selectWithType:1 offset:self.offset success:^(id responseObj) {
        
        if (self.offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        
        NSArray *array_callback = responseObj;
        if (array_callback == nil || array_callback.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }else{
            
            NSMutableArray *arrmu;
            if (self.offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (NSInteger i = 0; i < array_callback.count; i++) {
                DJUcMyCollectLessonModel *model = [DJUcMyCollectLessonModel mj_objectWithKeyValues:array_callback[i]];
                [arrmu addObject:model];
            }
            
            self.dataArray = arrmu.copy;
            self.offset = self.dataArray.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJUcMyCollectLessonModel *model = self.dataArray[indexPath.row];
    DJUcMyCollectLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:mclCell forIndexPath:indexPath];
    cell.collectModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /// 编辑状态
    DJUcMyCollectModel *model = self.dataArray[indexPath.row];
    model.select = !model.select;
}



@end
