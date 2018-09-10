//
//  DJThreemeetListViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThreemeetListViewController.h"
#import "DJOnlineNetorkManager.h"
#import "DJShowThemeAndMeetingTableViewController.h"/// 展示详情数据
#import "OLMindReportTableViewCell.h"
#import "DJThemeMeetingsModel.h"

@interface DJThreemeetListViewController ()
@property (assign,nonatomic) NSInteger offset;

@end

@implementation DJThreemeetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self upload_reloadData];
}

- (void)upload_reloadData{
    _offset = 0;
    [self getNetDataWithOffset:_offset];
}

- (void)getNetDataWithOffset:(NSInteger)offset{
    [DJOnlineNetorkManager.sharedInstance frontSessionsWithSessiontype:_sessionType offset:_offset length:10 success:^(id responseObj) {
        NSArray *array = responseObj;
        BOOL arrayIsNull = (array == nil || array.count == 0);
        
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            if (arrayIsNull) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        if (arrayIsNull) {
            return;
        }else{
            NSMutableArray *mutabelArray;
            if (offset == 0) {
                mutabelArray = NSMutableArray.new;
            }else{
                mutabelArray = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dict = array[i];
                DJThemeMeetingsModel  *model = [DJThemeMeetingsModel mj_objectWithKeyValues:dict];
                [mutabelArray addObject:model];
            }
            self.dataArray = mutabelArray.copy;
            _offset = self.dataArray.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
}


#pragma mark - delegate
/// MARK: tablview 代理、数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJThemeMeetingsModel *model = self.dataArray[indexPath.row];
    OLMindReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJThemeMeetingsModel *model = self.dataArray[indexPath.row];
    
    NSArray *dataArray = [model tableModelsWithType:1];
    
    /// 进入详情页面
    DJShowThemeAndMeetingTableViewController *vc = DJShowThemeAndMeetingTableViewController.new;
    vc.tmOrTd = 1;
    vc.dataArray = dataArray;
//    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - config UI
- (void)configUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    /// 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self getNetDataWithOffset:_offset];
    }];
    /// 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNetDataWithOffset:_offset];
    }];
    
}


@end
