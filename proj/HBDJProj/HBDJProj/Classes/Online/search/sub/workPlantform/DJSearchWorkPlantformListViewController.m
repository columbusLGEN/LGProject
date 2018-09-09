//
//  DJSearchWorkPlantformListViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSearchWorkPlantformListViewController.h"
#import "DJSearchWorkPlantformCell.h"
#import "DJThemeMeetingsModel.h"
#import "DJOnlineNetorkManager.h"
#import "DJShowThemeAndMeetingTableViewController.h"
#import "DJThoughtReportDetailViewController.h"

@interface DJSearchWorkPlantformListViewController ()
@property (assign,nonatomic) NSInteger offset;

@end

@implementation DJSearchWorkPlantformListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:searchWPCell bundle:nil] forCellReuseIdentifier:searchWPCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self getNetDataWithOffset:0];
    }];

    /// 添加上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNetDataWithOffset:_offset];
    }];
}

- (void)getNetDataWithOffset:(NSInteger)offset{
    [DJOnlineNetorkManager.sharedInstance frontIndex_onlineSearchWithContent:_searchContent type:1 offset:offset success:^(id responseObj) {
        
        NSArray *array = responseObj;
        
        if (offset == 0) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_header endRefreshing];
        }
        
        if (array == nil || array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }else{
            [self.tableView.mj_footer endRefreshing];
            
            NSMutableArray *arrmu;
            if (offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (NSInteger i = 0; i < array.count; i++) {
                DJThemeMeetingsModel *model = [DJThemeMeetingsModel mj_objectWithKeyValues:array[i]];
                [arrmu addObject:model];
            }
            self.dataArray = arrmu.copy;
            _offset = self.dataArray.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    _offset = dataArray.count;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJThemeMeetingsModel *model = self.dataArray[indexPath.row];
    DJSearchWorkPlantformCell *cell = [tableView dequeueReusableCellWithIdentifier:searchWPCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJThemeMeetingsModel *model = self.dataArray[indexPath.row];
//    model.searchtype;
    
    if (model.searchtype == 2 || model.searchtype == 4) {
        /// 进入思想汇报 或者 述职述廉 详情
        DJThoughtReportDetailViewController *detailvc = DJThoughtReportDetailViewController.new;
        detailvc.trOrSp = model.searchtype;
        detailvc.model = model;
        [self.navigationController pushViewController:detailvc animated:YES];
        
    }else{
        NSArray *dataArray;
        NSInteger tmOrTd = 1;
        if (model.searchtype == 1) {
            /// 三会一课
            dataArray = [model tableModelsWithType:1];
            tmOrTd = 1;
        }else{
            /// 主题党日
            dataArray = [model tableModelsWithType:0];
            tmOrTd = 3;
        }
        
        /// 进入三会一课或者主题党日 详情页面
        DJShowThemeAndMeetingTableViewController *vc = DJShowThemeAndMeetingTableViewController.new;
        vc.tmOrTd = tmOrTd;
        vc.dataArray = dataArray;
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
